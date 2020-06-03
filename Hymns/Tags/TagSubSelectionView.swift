import SwiftUI
import Resolver

struct TagSubSelectionList: View {
    let tagSelected: SongResultViewModel
    @ObservedObject private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel = Resolver.resolve(), tagSelected: SongResultViewModel) {
        self.viewModel = viewModel
        self.tagSelected = tagSelected
    }

    var body: some View {
        VStack {
            List(self.viewModel.tags) { tag in
                NavigationLink(destination: tag.destinationView) {
                    SongResultView(viewModel: tag)
                }
            }
        }.onAppear {
            self.viewModel.fetchTags(self.tagSelected.title)
        }
    }
}
