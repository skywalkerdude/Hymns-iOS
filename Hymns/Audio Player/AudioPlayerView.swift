import SwiftUI
import AVFoundation
import Combine

enum PlaybackState: Int {
    case waitingForSelection
    case buffering
    case playing
}

struct AudioView: View {
    let player = AVPlayer()
    let item: URL?
    @State var currentlyPlaying = false
    @State var playbackState: PlaybackState = .waitingForSelection

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player), playbackState: $playbackState)
            if playbackState != .buffering {
                HStack(spacing: 30) {

                    //Button to toggle play and pause
                    Button(action: {
                        if self.currentlyPlaying {
                            self.player.play()
                        } else {
                            self.player.pause()
                        }
                        self.currentlyPlaying.toggle()
                    }, label: {Image(systemName: currentlyPlaying ? "play.circle" : "pause.circle")
                        .font(.largeTitle)
                    })
                    
                    //Stop button to stop music completely
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
                    }, label: {Image(systemName: "stop.circle")
                        .font(.largeTitle)
                    })
                }
            }
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
