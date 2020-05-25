import SwiftUI
import Resolver

struct DisplayHymnToolbar: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: DisplayHymnViewModel

    //Only used for font size ellipsis
    @State private var tabPresented: DisplayHymnActionSheet?
    let userDefaultsManager: UserDefaultsManager = Resolver.resolve()

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            //Go back button
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left").accentColor(.primary)
            })
            Spacer()
            Text(viewModel.title).fontWeight(.bold)
            Spacer()
            viewModel.isFavorited.map { isFavorited in
                Group {
                    //Favorite heart button
                    Button(action: {
                        self.viewModel.toggleFavorited()
                    }, label: {
                        isFavorited ? Image(systemName: "heart.fill").accentColor(.accentColor) : Image(systemName: "heart").accentColor(.primary)
                    })
                    //Font size button
                    Button(action: {self.tabPresented = .fontSize}, label: {
                        Image(systemName: "ellipsis").rotationEffect(.degrees(90)).foregroundColor(.primary)
                    })
                }
            } //Action sheet is for the font selection toggle
        }.actionSheet(item: $tabPresented) { tab -> ActionSheet in
            switch tab {
            case .fontSize:
                return
                    ActionSheet(
                        title: Text("Font size"),
                        message: Text("Change the song lyrics font size"),
                        buttons: [
                            .default(Text(FontSize.normal.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .normal
                            }),
                            .default(Text(FontSize.large.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .large
                            }),
                            .default(Text(FontSize.xlarge.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .xlarge
                            }),
                            .cancel()])
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
            cupOfChrist.toPreviews("cup of christ")
        }.previewLayout(.fixed(width: 400, height: 50))
    }
}
#endif
