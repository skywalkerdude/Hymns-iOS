import SwiftUI

struct DisplayHymnToolbar: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: DisplayHymnViewModel

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left").accentColor(.primary)
            })
            Spacer()
            //Dynamic title on lyric view for when the user scrolls up and down. Other tabs stay with a static title
            if viewModel.currentTab.label == "Lyrics" {
                Text(viewModel.title).fontWeight(.bold).opacity(self.viewModel.position.posDeltaY >= (self.viewModel.position.posOriginY) ? 0 : 1) //Title to use scrolled in on a hymn
            } else {
                Text(viewModel.title).fontWeight(.bold)
            }
            Spacer()
            viewModel.isFavorited.map { isFavorited in
                Button(action: {
                    self.viewModel.toggleFavorited()
                }, label: {
                    isFavorited ? Image(systemName: "heart.fill").accentColor(.accentColor) : Image(systemName: "heart").accentColor(.primary)
                })
            }
        }.padding(.horizontal)
    }
}

#if DEBUG
struct DisplayHymnToolbar_Previews: PreviewProvider {
    static var previews: some View {
        let loading = DisplayHymnToolbar(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))

        let classic40ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40ViewModel.title = "Hymn 40"
        classic40ViewModel.isFavorited = true
        let classic40 = DisplayHymnToolbar(viewModel: classic40ViewModel)

        let classic1151ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.title = "Hymn 1151"
        classic1151ViewModel.isFavorited = false
        let classic1151 = DisplayHymnToolbar(viewModel: classic1151ViewModel)

        let cupOfChristViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        cupOfChristViewModel.title = "Cup of Christ"
        cupOfChristViewModel.isFavorited = true
        let cupOfChrist = DisplayHymnToolbar(viewModel: cupOfChristViewModel)
        return Group {
            loading.previewDisplayName("loading")
            classic40.previewDisplayName("classic 40")
            classic1151.previewDisplayName("classic 1151")
            cupOfChrist.previewDisplayName("cup of christ")
        }.previewLayout(.fixed(width: 400, height: 50))
    }
}
#endif
