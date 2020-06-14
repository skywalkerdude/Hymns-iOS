import SwiftUI
import AVFoundation
import Combine

enum PlaybackState: Int {
    case buffering
    case playing
    case stopped
}

class AudioPlayerViewModel: ObservableObject {

    @Published var playbackState: PlaybackState = .stopped
    @Published var shouldRepeat = false

    let player = AVPlayer()
    let timeObserver: PlayerTimeObserver
    let url: URL?
    let seekDuration: Float64 = 5

    private var playingFinishedObserver: Any?

    init(url: URL?) {
        self.url = url
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

    func convertFloatToCMTime(_ floatTime: Float64) -> CMTime {
        CMTimeMake(value: Int64(floatTime * 1000 as Float64), timescale: 1000)
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
