import Lottie
import SwiftUI

struct SoundCloudPlayer: View {

    @ObservedObject private var viewModel: SoundCloudPlayerViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    init(viewModel: SoundCloudPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.showPlayer {
            return HStack(spacing: 0) {
                if !sizeCategory.isAccessibilityCategory() {
                    LottieView(fileName: "soundCloudPlayingAnimation", shouldLoop: true)
                        .frame(width: 30, height: 20, alignment: .center).padding()
                }
                Button(action: {
                    self.viewModel.openPlayer()
                }, label: {
                    Text(NSLocalizedString("Now playing from SoundCloud",
                                           comment: "Indicator that a song from SoundCloud is currently playing"))
                        .foregroundColor(.accentColor).padding([.vertical, .trailing]).maxWidth(alignment: .leading)
                })
                Button(action: {
                    self.viewModel.dismissPlayer()
                }, label: {
                    Image(systemName: "xmark").accessibility(label: Text("Close")).padding().foregroundColor(.primary)
                })
            }.transition(.opacity).animation(.easeOut).eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
    }
}

#if DEBUG
struct SoundCloudPlayer_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil))
        viewModel.showPlayer = true
        return SoundCloudPlayer(viewModel: viewModel).toPreviews()
    }
}
#endif
