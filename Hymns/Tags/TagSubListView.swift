import SwiftUI
import Resolver

struct TagSubList: View {
    let tagSelected: SongResultViewModel
    @ObservedObject private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel = Resolver.resolve(), tagSelected: SongResultViewModel) {
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
