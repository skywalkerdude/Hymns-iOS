import AVFoundation
import FirebaseCrashlytics
import Combine
import Resolver
import SwiftUI

enum PlaybackState: Int {
    case buffering
    case playing
    case stopped
}

class AudioPlayerViewModel: NSObject, ObservableObject {

    @Published var playbackState: PlaybackState = .stopped
    @Published var shouldRepeat = false

    /**
     * Number of seconds to seek forward or backwards when rewind/fast-forward is triggered.
     */
    private let seekDuration: Float64 = 5

    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let url: URL
    private let service: HymnalNetService

    private var cancellable: AnyCancellable?
    private var interruptedObserver: Any?
    /* VISIBLE FOR UNIT TESTS. DO NOT USE OUTSIDE OF THIS CLASS */ var player: AVAudioPlayer?

    init(url: URL,
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         service: HymnalNetService = Resolver.resolve()) {
        self.url = url
        self.mainQueue = mainQueue
        self.backgroundQueue = backgroundQueue
        self.service = service

        // https://stackoverflow.com/questions/30832352/swift-keep-playing-sounds-when-the-device-is-locked
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            Crashlytics.crashlytics().record(error: NonFatal(errorDescription: "Unable to set AVAudioSession category to \(AVAudioSession.Category.playback.rawValue)"))
        }
    }

    func toggleRepeat() {
        shouldRepeat.toggle()
    }

    func reset() {
        playbackState = .stopped
        shouldRepeat = false
        player?.stop()
        player = nil
        interruptedObserver = nil
        load()
    }

    func rewind() {
        guard let player = player else {
            return
        }
        let rewoundTime = player.currentTime - seekDuration
        player.currentTime = rewoundTime >= TimeInterval.zero ? rewoundTime : TimeInterval.zero
    }

    func fastForward() {
        guard let player = player else {
            return
        }
        let fastForwardedTime = player.currentTime + seekDuration
        player.currentTime = fastForwardedTime <= player.duration ? fastForwardedTime : player.duration
    }

    func play() {
        playbackState = .buffering
        guard let player = player else {
            load(completion: { player in
                self.playbackState = .playing
                player.play()
            }, failed: {
                self.playbackState = .stopped
            })
            return
        }
        playbackState = .playing
        player.play()
    }

    func load(completion: ((_ player: AVAudioPlayer) -> Void)? = nil, failed: (() -> Void)? = nil) {
        if let cancellable = cancellable {
            cancellable.cancel()
        }
        cancellable = service.getData(url)
            .subscribe(on: backgroundQueue)
            .tryMap({ data -> AVAudioPlayer in
                try AVAudioPlayer(data: data)
            })
            .replaceError(with: nil)
            .receive(on: mainQueue)
            .sink { [weak self] audioPlayer in
                guard let self = self else { return }
                self.player = audioPlayer
                guard let player = self.player else {
                    if let failed = failed {
                        failed()
                    }
                    Crashlytics.crashlytics().record(error: NonFatal(errorDescription: "Failed to initialize audio player"))
                    return
                }
                self.interruptedObserver
                    = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: nil, using: { _ in
                        self.pause()
                    })
                player.delegate = self
                if let completion = completion {
                    completion(player)
                }
        }
    }

    func pause() {
        playbackState = .stopped
        player?.pause()
    }
}

extension AudioPlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.currentTime = TimeInterval.zero
        if self.shouldRepeat {
            player.play()
        } else {
            self.playbackState = .stopped
            player.stop()
        }
    }
}

extension AudioPlayerViewModel {

    override func isEqual(_ object: Any?) -> Bool {
        return url == (object as? AudioPlayerViewModel)?.url
    }

    override var hash: Int {
        return url.hashValue
    }
}
