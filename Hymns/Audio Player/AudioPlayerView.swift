import SwiftUI
import AVFoundation
import Combine

struct AudioView: View {
    let player = AVPlayer()
    let item: URL?

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player))
            HStack {
            Button(action: {
                guard let url = self.item else {
                    return
                }
                let playerItem = AVPlayerItem(url: url)
                self.player.replaceCurrentItem(with: playerItem)
                self.player.play()
            }) {Image(systemName: "play")}
            
            Button(action: {
                guard let url = self.item else {
                    return
                }
             //   let playerItem = AVPlayerItem(url: url)
            //    self.player.replaceCurrentItem(with: playerItem)
                self.player.pause()
            }) {Image(systemName: "stop")}
            }
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}
