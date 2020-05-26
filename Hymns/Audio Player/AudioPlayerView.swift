import SwiftUI
import AVFoundation
import Combine

enum PlaybackState: Int {
    case waitingForSelection
    case buffering
    case playing
}

struct AudioView: View {

    @State var currentlyPlaying = true
    @State var playbackState: PlaybackState = .waitingForSelection

    @ObservedObject private var viewModel: AudioPlayerViewModel

    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: viewModel.player,
                                    timeObserver: PlayerTimeObserver(player: viewModel.player),
                                    itemObserver: PlayerItemObserver(player: viewModel.player), playbackState: $playbackState)
            HStack(spacing: 30) {

                // TODO Keep the music playing when you tab between piano, chords, etc.
                //Reset button currently needed for when you tab to chords, piano, or guitar....
                Button(action: {
                    self.currentlyPlaying = false
                    self.playbackState = .buffering
                    self.viewModel.player.replaceCurrentItem(with: nil)
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
                    if self.currentlyPlaying {
                        self.viewModel.player.play()
                    } else {
                        self.viewModel.player.pause()
                    }
                    self.currentlyPlaying.toggle()
                }, label: {Image(systemName: currentlyPlaying ? "play.circle" : "pause.circle")
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
