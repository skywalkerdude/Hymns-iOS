import SwiftUI
import AVFoundation
import Combine

// https://github.com/ChrisMash/AVPlayer-SwiftUI
// https://medium.com/flawless-app-stories/avplayer-swiftui-part-2-player-controls-c28b721e7e27
// TODO For some reason the combine stuff isn't working with our URLS that aren't straight up mp3 urls for example http://www.hymnal.net/en/hymn/h/894/f=mp3 that is coming from musicJson. However, the combine works when the url is a direct mp3 url such as https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3
struct AudioPlayer: View {

    @State var currentlyPlaying = false
    @State var repeating = false

    @ObservedObject private var viewModel: AudioPlayerViewModel

    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 40) {
            // Reset button
            Button(action: {
                self.currentlyPlaying = false
                guard let url = self.viewModel.item else {
                    return
                }
                let playerItem = AVPlayerItem(url: url)
                self.viewModel.player.replaceCurrentItem(with: playerItem)
                self.viewModel.player.play()
            }, label: {
                Image(systemName: "backward.end.fill").font(.subheadline).foregroundColor(.primary)
            })

            // Rewind button
            Button(action: {
                let rewoundTime = self.viewModel.convertFloatToCMTime(self.viewModel.playerCurrentTime - self.viewModel.seekDuration)
                self.viewModel.player.seek(to: rewoundTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            }, label: {
                Image(systemName: "backward.fill").font(.subheadline).foregroundColor(.primary)
            })

            // Play/Pause button
            Button(action: {
                self.currentlyPlaying.toggle()
                if self.currentlyPlaying {
                    self.viewModel.player.play()
                } else {
                    self.viewModel.player.pause()
                }
            }, label: {Image(systemName: currentlyPlaying ? "pause.circle" : "play.circle")
                .font(.largeTitle).foregroundColor(.primary)
            })

            // Fast-forward button
            Button(action: {
                let fastForwardedTime = self.viewModel.convertFloatToCMTime(self.viewModel.playerCurrentTime + self.viewModel.seekDuration)
                self.viewModel.player.seek(to: fastForwardedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            }, label: {
                Image(systemName: "forward.fill").font(.subheadline).foregroundColor(.primary)
            })

            // Repeat button
            Button(action: {
                self.repeating.toggle()
                // TODO implement repeating
            }, label: {
                Image(systemName: "repeat").font(.subheadline).foregroundColor(repeating ? .accentColor : .primary)
            })
        }.onAppear {
            guard let url = self.viewModel.item else {
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.viewModel.player.replaceCurrentItem(with: playerItem)
        }.onDisappear {
            // When this View isn't being shown anymore stop the player
            self.viewModel.player.replaceCurrentItem(with: nil)
        }
    }
}

#if DEBUG
struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AudioPlayerViewModel(item: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=mp3")!)
        return Group {
            AudioPlayer(viewModel: viewModel).previewLayout(.sizeThatFits)
        }
    }
}
#endif
