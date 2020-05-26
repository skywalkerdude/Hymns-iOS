import SwiftUI
import AVFoundation
import Combine

class AudioPlayerViewModel: ObservableObject {

    init(item: URL?) {
        self.item = item
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
