import SwiftUI
import Resolver

struct TagListView: View {
    @State var unique = [SongResultViewModel]()
    @ObservedObject private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if self.viewModel.tags.isEmpty {
                EmptyView()
            } else {
                List(self.unique) { tag in
                    NavigationLink(destination: TagSubSelectionList(tagSelected: tag)) {
                        SongResultView(viewModel: tag)
                    }
                }.resignKeyboardOnDragGesture()
            }
        }.onAppear {
            self.viewModel.fetchTags(nil)
            self.storeUniqueTags(self.viewModel.tags)
        }
    }

    //Takes all of the fetched hymnTags and stores only the unique tag names for us to iterate through
    private func storeUniqueTags(_ taggedHymn: [SongResultViewModel] ) {
        for hymn in taggedHymn {
            if self.unique.contains(hymn) {
                continue
            } else {
                self.unique.append(hymn)
            }
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}

