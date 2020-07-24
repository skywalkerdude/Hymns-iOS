import SwiftUI
import AVFoundation
import Combine

// https://github.com/ChrisMash/AVPlayer-SwiftUI
// https://medium.com/flawless-app-stories/avplayer-swiftui-part-2-player-controls-c28b721e7e27
struct AudioPlayer: View {

    @ObservedObject private var viewModel: AudioPlayerViewModel

    @State private var currentTime: Double = 0

    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
        self.viewModel.timer.connect().cancel()
    }

    var body: some View {
        VStack {
            HStack {
                viewModel.player.map { _ in
                    Slider(value: $currentTime,
                           in: 0...Double(self.viewModel.player?.duration ?? 0),
                           onEditingChanged: sliderEditingChanged,
                           minimumValueLabel: Text("\(TimeFormating.formatSecondsToHMS(currentTime))").foregroundColor(.accentColor),
                           maximumValueLabel: Text("\(TimeFormating.formatSecondsToHMS(self.viewModel.player?.duration ?? 0))")) {
                            Text("")
                    }
                }
            }
            .onReceive(self.viewModel.timer) { _ in
                if self.currentTime < ((self.viewModel.player?.duration ?? 0) - 1) {
                    self.currentTime += 1
                } else {
                    self.currentTime = self.viewModel.toZero()
                }
            }

            HStack(spacing: 40) {
            // Reset button
            Button(action: {
                self.currentTime = 0
                self.viewModel.timer.connect().cancel()
                self.viewModel.reset()
                self.viewModel.play()
            }, label: {
                Image(systemName: "backward.end.fill").font(.system(size: smallButtonSize)).foregroundColor(.primary)
            })

            // Rewind button
            Button(action: {
                self.currentTime = self.viewModel.rewind()
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
                self.currentTime = self.viewModel.fastForward()
            }, label: {
                Image(systemName: "forward.fill").font(.system(size: smallButtonSize)).foregroundColor(.primary)
            })

            // Repeat button
            Button(action: {
                self.viewModel.shouldRepeat.toggle()
            }, label: {
                Image(systemName: "repeat").font(.system(size: smallButtonSize)).foregroundColor(viewModel.shouldRepeat ? .accentColor : .primary)
            })
            }
        }.onDisappear {
            // when this view isn't being shown anymore stop the player
            self.viewModel.pause()
        }
    }
    private func sliderEditingChanged(editingStarted: Bool) {
            if editingStarted {
                // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
                // with the slider (otherwise it would keep jumping from where they've moved it to, back
                // to where the player is currently at)
                self.viewModel.timer.connect().cancel()
            } else {
                // Editing finished, start the seek
                self.viewModel.timer = Timer.publish(every: 1, on: .main, in: .common)
                self.viewModel.timer.connect()
                let targetTime = currentTime
                self.viewModel.player?.currentTime = targetTime
            }
        }
}

#if DEBUG
struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)
        return Group {
            AudioPlayer(viewModel: viewModel).previewLayout(.sizeThatFits)
        }
    }
}
#endif
