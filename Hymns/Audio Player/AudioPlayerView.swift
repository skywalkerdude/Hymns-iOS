import SwiftUI
import AVFoundation
import Combine

struct AudioView: View {
    let player = AVPlayer()
    let item: URL?
    @State var currentlyPlaying = false

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player))
            Button(action: {
                if self.currentlyPlaying {
                    guard let url = self.item else {
                        return
                    }
                    let playerItem = AVPlayerItem(url: url)
                    self.player.replaceCurrentItem(with: playerItem)
                    self.player.play()
                } else {
                    self.player.pause()
                }
                self.currentlyPlaying.toggle()
            }, label: {Image(systemName: currentlyPlaying ? "play.circle" : "stop.circle")
                .font(.largeTitle)
            })
        }.onAppear() {
            guard let url = self.item else {
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}
