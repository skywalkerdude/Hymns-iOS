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
                VStack(spacing: 5) {
                    Image("empty tag illustration")
                    Text("Create tags by tapping on the")
                    HStack {
                        Image(systemName: "tag")
                        Text("icon on any hymn")
                    }.multilineTextAlignment(.center)
                }.maxSize().background(Color(.systemBackground))
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
        let withTagsViewModel = TagListViewModel()
        withTagsViewModel.tags = ["tag 1", "tag 2", "tag 3", "tag 4"]
        let withTags = TagListView(viewModel: withTagsViewModel)

        let noTagsViewModel = TagListViewModel()
        let empty = TagListView(viewModel: noTagsViewModel)

        return Group {
            withTags.previewDisplayName("saved tags")
            empty.previewDisplayName("no saved tags")
        }
    }
}
