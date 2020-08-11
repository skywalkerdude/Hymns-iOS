import SwiftUI

struct SoundCloudPlayer: View {

    @ObservedObject private var viewModel: SoundCloudPlayerViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    init(viewModel: SoundCloudPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.showPlayer {
            return HStack {
                if !sizeCategory.isAccessibilityCategory() {
                    Image("soundcloud_logo").padding()
                }
                Button(action: {
                    self.viewModel.openPlayer()
                }, label: {
                    Text(NSLocalizedString("Now playing from SoundCloud",
                                           comment: "Indicator that a song from SoundCloud is currently playing"))
                        .foregroundColor(.accentColor).maxWidth()
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
