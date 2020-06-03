import SwiftUI
import Resolver

struct TagSubSelectionList: View {
    let tagSelected: SongResultViewModel
    @ObservedObject private var viewModel: TagsViewModel

    init(viewModel: TagsViewModel = Resolver.resolve(), tagSelected: SongResultViewModel) {
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
            self.viewModel.fetchTagsByTags(self.tagSelected.title)
        }
    }
}
