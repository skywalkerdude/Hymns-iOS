import SwiftUI
import Resolver

struct TagSheetView: View {

    let favoritesStore: FavoritesStore = Resolver.resolve()
    @Environment(\.presentationMode) var presentationMode
    @State private var tagNames = ""
    private var title: String
    private var hymnIdentifier: HymnIdentifier

    init(title: String, hymnIdentifier: HymnIdentifier) {
        self.hymnIdentifier = hymnIdentifier
        self.title = title
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Label your tag")
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                HStack {
                    TextField("Add tags", text: self.$tagNames)
                    Button("Add") {
                        self.favoritesStore.storeFavorite(FavoriteEntity(hymnIdentifier: self.hymnIdentifier, songTitle: self.title, tags: self.tagNames))
                    }
                }
            }
        }
    }
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView(title: "Lord's Table", hymnIdentifier: PreviewHymnIdentifiers.hymn1151)
    }
}
