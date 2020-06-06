import SwiftUI
import Resolver

struct TagListView: View {

    @ObservedObject private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List(viewModel.tags, id: \.self) { tag in
                NavigationLink(destination: BrowseResultsListView(viewModel: BrowseResultsListViewModel(tag: tag))) {
                    Text(tag)
                }
            }
        }.onAppear {
            self.viewModel.getUniqueTags()
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TagListViewModel()
        viewModel.tags = ["tag 1", "tag 2", "tag 3", "tag 4"]
        return TagListView(viewModel: viewModel)
    }
}
