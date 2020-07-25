import SwiftUI
import AVFoundation
import Combine

// https://github.com/ChrisMash/AVPlayer-SwiftUI
// https://medium.com/flawless-app-stories/avplayer-swiftui-part-2-player-controls-c28b721e7e27
struct AudioPlayer: View {

    @ObservedObject private var viewModel: AudioPlayerViewModel

    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            AudioSlider(viewModel: viewModel)
            HStack(spacing: 40) {
                // Reset button
                Button(action: {
                    self.viewModel.reset()
                }, label: {
                    Image(systemName: "backward.end.fill").font(.system(size: smallButtonSize)).foregroundColor(.primary)
                })

                // Rewind button
                Button(action: {
                    self.viewModel.rewind()
                }, label: {
                    Image(systemName: "backward.fill").font(.system(size: smallButtonSize)).foregroundColor(.primary)
                })

                // Play/Pause button
                Button(action: {
                    switch self.viewModel.playbackState {
                    case .buffering:
                        break
                    case .playing:
                        self.viewModel.pause()
                    case .stopped:
                        self.viewModel.play()
                    }
                }, label: {
                    if viewModel.playbackState == .buffering {
                        ActivityIndicator().font(.largeTitle).foregroundColor(.primary)
                    } else if viewModel.playbackState == .playing {
                        Image(systemName: "pause.circle").font(.system(size: largeButtonSize)).foregroundColor(.primary)
                    } else {
                        // viewModel.playbackState == .stopped
                        Image(systemName: "play.circle").font(.system(size: largeButtonSize)).foregroundColor(.primary)
                    }
                })

                // Fast-forward button
                Button(action: {
                    self.viewModel.fastForward()
                }, label: {
                    Image(systemName: "forward.fill").font(.system(size: smallButtonSize)).foregroundColor(.primary)
                })

                // Repeat button
                Button(action: {
                    self.viewModel.toggleRepeat()
                }, label: {
                    Image(systemName: "repeat").font(.system(size: smallButtonSize)).foregroundColor(viewModel.shouldRepeat ? .accentColor : .primary)
                })
            }
        }.onAppear {
            self.viewModel.load()
        }.onDisappear {
            // when this view isn't being shown anymore stop the player
            self.viewModel.pause()
        }
    }
}

#if DEBUG
struct AudioView_Previews: PreviewProvider {
    static var previews: some View {

        let playingViewModel = AudioPlayerViewModel(url: URL(string: "url")!)
        playingViewModel.playbackState = .playing
        playingViewModel.songDuration = 100
        playingViewModel.currentTime = 50
        let currentlyPlaying = AudioPlayer(viewModel: playingViewModel)

        let stoppedViewModel = AudioPlayerViewModel(url: URL(string: "url")!)
        stoppedViewModel.playbackState = .stopped
        stoppedViewModel.songDuration = 500
        stoppedViewModel.shouldRepeat = true
        let stopped = AudioPlayer(viewModel: stoppedViewModel)

        let bufferingViewModel = AudioPlayerViewModel(url: URL(string: "url")!)
        bufferingViewModel.playbackState = .buffering
        bufferingViewModel.songDuration = 20
        let buffering = AudioPlayer(viewModel: bufferingViewModel)

        return Group {
            currentlyPlaying.previewDisplayName("currently playing")
            stopped.previewDisplayName("stopped")
            buffering.previewDisplayName("buffering")
        }.padding().previewLayout(.sizeThatFits)
    }
}
#endif
