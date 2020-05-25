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
    fileprivate let seekDuration: Float64 = 5
    fileprivate var playerCurrentTime: Float64 {
        CMTimeGetSeconds(self.player.currentTime())
    }

    @State var currentlyPlaying = true
    @State var playbackState: PlaybackState = .waitingForSelection

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player), playbackState: $playbackState)
            HStack(spacing: 30) { 
                //Reset button currently needed for when you tab to chords, piano, or guitar....
                Button(action: {
                    if self.currentlyPlaying {
                        self.currentlyPlaying.toggle()
                    }
                    self.playbackState = .buffering
                    self.player.replaceCurrentItem(with: nil)
                    guard let url = self.item else {
                        return
                    }
                    let playerItem = AVPlayerItem(url: url)
                    self.player.replaceCurrentItem(with: playerItem)
                    self.player.play()
                }, label: {
                    Image(systemName: "backward.end")
                })

                //Button to rewind 15 seconds
                Button(action: {
                    let rewoundTime = Utility.convertFloatToCMTime(self.playerCurrentTime - self.seekDuration)
                    self.player.seek(to: rewoundTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                }, label: {Image(systemName: "backward")
                })

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

                //Button to fast forward 15 seconds
                Button(action: {
                    let fastForwardedTime = Utility.convertFloatToCMTime(self.playerCurrentTime + self.seekDuration)
                    self.player.seek(to: fastForwardedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                }, label: {
                    Image(systemName: "forward")
                })
            }
        }.onAppear {
            guard let url = self.item else {
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}
