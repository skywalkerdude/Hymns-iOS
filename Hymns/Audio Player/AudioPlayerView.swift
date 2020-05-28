import SwiftUI
import AVFoundation
import Combine

struct AudioView: View {

    //A second state variable play button toggle is necessary because currentlyplaying is also in control of graying out the music player and working with seeking. We don't want the music player to be greyed out and unavailable everytime we pause the music.
    @State var currentlyPlaying = false
    @State var playButtonToggle = true

    @ObservedObject private var viewModel: AudioPlayerViewModel

    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: viewModel.player,
                                    timeObserver: PlayerTimeObserver(player: viewModel.player), currentlyPlaying: $currentlyPlaying)
            HStack(spacing: 30) {
                //Reset button
                Button(action: {
                    self.playButtonToggle = false
                    guard let url = self.viewModel.item else {
                        return
                    }
                    let playerItem = AVPlayerItem(url: url)
                    self.viewModel.player.replaceCurrentItem(with: playerItem)
                    self.viewModel.player.play()
                }, label: {
                    Image(systemName: "backward.end")
                })

                //Button to rewind
                Button(action: {
                    let rewoundTime = self.viewModel.convertFloatToCMTime(self.viewModel.playerCurrentTime - self.viewModel.seekDuration)
                    self.viewModel.player.seek(to: rewoundTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                }, label: {Image(systemName: "backward")
                })

                //Button to toggle play and pause
                Button(action: {
                    if self.playButtonToggle {
                        self.viewModel.player.play()
                    } else {
                        self.viewModel.player.pause()
                    }
                    self.playButtonToggle.toggle()
                }, label: {Image(systemName: playButtonToggle ? "play.circle" : "pause.circle")
                    .font(.largeTitle)
                })

                //Button to fast forward
                Button(action: {
                    let fastForwardedTime = self.viewModel.convertFloatToCMTime(self.viewModel.playerCurrentTime + self.viewModel.seekDuration)
                    self.viewModel.player.seek(to: fastForwardedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                }, label: {
                    Image(systemName: "forward")
                })
            }
        }.onAppear {
            guard let url = self.viewModel.item else {
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.viewModel.player.replaceCurrentItem(with: playerItem)
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.viewModel.player.replaceCurrentItem(with: nil)
        }
    }
}
