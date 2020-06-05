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
            self.viewModel.fetchUniqueTags()
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
