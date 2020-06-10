import SwiftUI
import Resolver

struct TagListView: View {

    @ObservedObject private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.tags.isEmpty {
                VStack {
                    Image("empty tag illustration")
                    Text("Create tags by tapping on the tag icon on any hymn").padding().multilineTextAlignment(.center)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color(.systemBackground))
            } else {
            List(viewModel.tags, id: \.self) { tag in
                NavigationLink(destination: BrowseResultsListView(viewModel: BrowseResultsListViewModel(tag: tag))) {
                    Text(tag)
                }
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
