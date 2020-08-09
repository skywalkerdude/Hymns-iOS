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
                    Image("soundcloud_logo")
                }
                Text(NSLocalizedString("Now playing from SoundCloud",
                                       comment: "Indicator that a song from SoundCloud is currently playing"))
                    .foregroundColor(.secondary).maxWidth()
                Button(action: {
                    self.viewModel.stopPlayer()
                }, label: {
                    Image(systemName: "xmark")
                        .accessibility(label: Text(NSLocalizedString("Close",
                                                                     comment: "Close button on the SoundCloud player")))
                })
            }.eraseToAnyView()
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
