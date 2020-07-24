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

class AudioPlayerViewModel: ObservableObject {

    @Published var playbackState: PlaybackState = .stopped
    @Published var shouldRepeat = false

    @Published var timer = Timer.publish(every: 1, on: .main, in: .common)

    /**
     * Number of seconds to seek forward or backwards when rewind/fast-forward is triggered.
     */
    let seekDuration: Float64 = 5

    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let url: URL
    private let service: HymnalNetService

    private var disposables = Set<AnyCancellable>()
    @Published var player: AVAudioPlayer?
    private var playingFinishedObserver: Any?

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
        player?.stop()
        player = nil
        playingFinishedObserver = nil
    }

    func rewind() -> Double {
        guard let player = player else {
            return 0
        }
        let rewoundTime = player.currentTime - seekDuration
        player.currentTime = rewoundTime >= TimeInterval.zero ? rewoundTime : TimeInterval.zero
        return player.currentTime
    }

    func fastForward() -> Double {
        guard let player = player else {
            return 0
        }
        let fastForwardedTime = player.currentTime + seekDuration
        player.currentTime = fastForwardedTime <= player.duration ? fastForwardedTime : TimeInterval.zero
        return player.currentTime
    }

    func play() {
        playbackState = .buffering
        guard let player = player else {
            service.getData(url)
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
                        self.playbackState = .stopped
                        Crashlytics.crashlytics().record(error: NonFatal(errorDescription: "Failed to initialize audio player"))
                        return
                    }

                    self.timer = Timer.publish(every: 1, on: .main, in: .common)
                    self.timer.connect()
                    self.playingFinishedObserver =
                        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                            player.currentTime = TimeInterval.zero
                            if self.shouldRepeat {
                                player.play()
                            } else {
                                self.playbackState = .stopped
                            }
                    }
                    self.playbackState = .playing
                    player.play()
            }.store(in: &disposables)
            return
        }
        playbackState = .playing
        player.play()
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.timer.connect()
    }

    func pause() {
        playbackState = .stopped
        self.timer.connect().cancel()
        player?.pause()
    }
}

extension AudioPlayerViewModel: Equatable {
    static func == (lhs: AudioPlayerViewModel, rhs: AudioPlayerViewModel) -> Bool {
        lhs.url == rhs.url
    }
}
