import AVFoundation
import FirebaseCrashlytics
import Combine
import SwiftUI

enum PlaybackState: Int {
    case buffering
    case playing
    case stopped
}

class AudioPlayerViewModel: ObservableObject {

    @Published var playbackState: PlaybackState = .stopped
    @Published var shouldRepeat = false

    let timeObserver: PlayerTimeObserver

    private let player = AVPlayer()
    private let url: URL

    /**
     * Number of seconds to seek forward or backwards when rewind/fast-forward is triggered.
     */
    private let seekDuration: Float64 = 5

    private var playingFinishedObserver: Any?

    init(url: URL) {
        self.url = url
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)

        // https://stackoverflow.com/questions/30832352/swift-keep-playing-sounds-when-the-device-is-locked
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            Crashlytics.crashlytics().record(error: NonFatal(errorDescription: "Unable to set AVAudioSession category to \(AVAudioSession.Category.playback.rawValue)"))
        }

        self.timeObserver = PlayerTimeObserver(player: player)
        self.playingFinishedObserver =
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                self.player.seek(to: CMTime.zero)
                if self.shouldRepeat {
                    self.player.play()
                } else {
                    self.playbackState = .stopped
                }
        }
    }

    func toggleRepeat() {
        shouldRepeat.toggle()
    }

    var playerCurrentTime: Float64 {
        CMTimeGetSeconds(self.player.currentTime())
    }

    private func convertFloatToCMTime(_ floatTime: Float64) -> CMTime {
        CMTimeMake(value: Int64(floatTime * 1000 as Float64), timescale: 1000)
    }

    func reset() {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }

    func rewind() {
        let rewoundTime = convertFloatToCMTime(playerCurrentTime - seekDuration)
        player.seek(to: rewoundTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }

    func fastForward() {
        let fastForwardedTime = convertFloatToCMTime(playerCurrentTime + seekDuration)
        player.seek(to: fastForwardedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }

    func play() {
        playbackState = .buffering
        timeObserver.play()
        player.play()
    }

    func pause() {
        playbackState = .stopped
        timeObserver.pause()
        player.pause()
    }
}

extension AudioPlayerViewModel: Equatable {
    static func == (lhs: AudioPlayerViewModel, rhs: AudioPlayerViewModel) -> Bool {
        lhs.url == rhs.url
    }
}
