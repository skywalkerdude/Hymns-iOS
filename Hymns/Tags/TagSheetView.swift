import SwiftUI
import Resolver

struct TagSheetView: View {

    let favoritesStore: FavoritesStore
    @ObservedObject private var viewModel: FavoritesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tagNames = ""
    private var title: String
    private var hymnIdentifier: HymnIdentifier

    init(title: String, hymnIdentifier: HymnIdentifier, viewModel: FavoritesViewModel = Resolver.resolve(), favoritesStore: FavoritesStore = Resolver.resolve()) {
        self.hymnIdentifier = hymnIdentifier
        self.title = title
        self.viewModel = viewModel
        self.favoritesStore = favoritesStore
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
                          self.viewModel.fetchHymnTags(hymnSelected: self.hymnIdentifier)
                    }
                }
            }

                        Section {
                            HStack {
                                ForEach(self.viewModel.tags, id: \.self) { tag in
                                    Button(action: {
                                        //TODO FIX Delete is deleting all the tags because the button when clicked is clicking all of them.
                                        self.favoritesStore.deleteFavoriteObject(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: self.hymnIdentifier, tags: tag.title), tags: tag.title)
                                        self.viewModel.fetchHymnTags(hymnSelected: self.hymnIdentifier)
                                    }, label: {
                                        HStack {
                                            SongResultView(viewModel: tag)
                                            Image(systemName: "xmark.circle")
                                        }
                                    })
                                        .padding()
                                        .foregroundColor(.primary)
                                        .background(Color.orange)
                                        .cornerRadius(.infinity)
                                        .lineLimit(1)
                                }
                            }
                        }.onAppear {
                            self.viewModel.fetchHymnTags(hymnSelected: self.hymnIdentifier)
        }
    }
}
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView(title: "Lord's Table", hymnIdentifier: PreviewHymnIdentifiers.hymn1151)
    }
}
