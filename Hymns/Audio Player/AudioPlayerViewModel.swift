import SwiftUI
import AVFoundation
import Combine

class AudioPlayerViewModel: ObservableObject {
    private var observer: Any?

    init(item: URL?) {
        self.item = item
    }

    //https://stackoverflow.com/questions/5361145/looping-a-video-with-avfoundation-avplayer
    //https://stackoverflow.com/questions/33388940/nsnotificationcenter-removeobserver-not-working
    func repeatingOn(audioPlayer: AVPlayer, looping: Bool) {
        if looping {
            observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                audioPlayer.seek(to: CMTime.zero)
                audioPlayer.play()
            }} else {
            guard let observer = observer else {
                return
            }
            NotificationCenter.default.removeObserver(observer)
        }
    }

    let player = AVPlayer()
    let item: URL?
    let seekDuration: Float64 = 15
    var playerCurrentTime: Float64 {
        CMTimeGetSeconds(self.player.currentTime())
    }

    func convertFloatToCMTime(_ floatTime: Float64) -> CMTime {
        CMTimeMake(value: Int64(floatTime * 1000 as Float64), timescale: 1000)
    }
}
