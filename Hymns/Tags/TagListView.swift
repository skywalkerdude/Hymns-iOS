import SwiftUI
import Resolver

struct TagListView: View {
    @State var unique = [String]()
    @ObservedObject private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
        if self.viewModel.favorites.isEmpty {
            VStack(spacing: 25) {
                Image("empty favorites illustration")
                Text("Tap the heart on any hymn to add as a favorite")
            }.maxSize().offset(y: -25)
        } else {
            List(self.viewModel.favorites) { favorite in
                NavigationLink(destination: favorite.destinationView) {
                    SongResultView(viewModel: favorite)
                }
            }.resignKeyboardOnDragGesture()
        }
        }.onAppear {
            self.viewModel.fetchFavorites()
        }
    }
}

//    var body: some View {
//        VStack {
//            List {
//                ForEach(self.unique, id: \.self) { hymn in
//                    VStack<AnyView> {
//                        NavigationLink(destination: TagSubSelectionList()) {
//                            Text(hymn)
//                        }.eraseToAnyView()
//                    }
//                }
//            }
//        }.onAppear {
//           // self.storeUniqueTags(self.taggedHymn)
//        }
//    }
//    //Takes all of the fetched hymnTags and stores only the unique tag names for us to iterate through
////    private func storeUniqueTags(_ taggedHymn: FetchedResults<TaggedHymn>) {
////        for hymn in self.taggedHymn {
////            if self.unique.contains(hymn.tagName ?? "") {
////                continue
////            } else {
////                self.unique.append(hymn.tagName ?? "")
////            }
////        }
////    }
//}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}

