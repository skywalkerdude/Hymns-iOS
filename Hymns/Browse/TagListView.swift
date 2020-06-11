import SwiftUI
import Resolver

struct TagListView: View {

    @ObservedObject private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group { () -> AnyView in
            guard let tags = viewModel.tags else {
                return ActivityIndicator().maxSize().eraseToAnyView()
            }
            guard !tags.isEmpty else {
                return VStack(spacing: 5) {
                    Image("empty tag illustration")
                    Text("Create tags by tapping on the")
                    HStack {
                        Image(systemName: "tag")
                        Text("icon on any hymn")
                    }.multilineTextAlignment(.center)
                }.maxSize().background(Color(.systemBackground)).eraseToAnyView()
            }
            return List(tags, id: \.self) { tag in
                NavigationLink(destination: BrowseResultsListView(viewModel: BrowseResultsListViewModel(tag: tag))) {
                    Text(tag)
                }
            }.eraseToAnyView()
        }.onAppear {
            self.viewModel.fetchUniqueTags()
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {

        let loadingViewModel = TagListViewModel()
        let loading = TagListView(viewModel: loadingViewModel)

        let emptyViewModel = TagListViewModel()
        emptyViewModel.tags = [String]()
        let empty = TagListView(viewModel: emptyViewModel)

        let withTagsViewModel = TagListViewModel()
        withTagsViewModel.tags = ["tag 1", "tag 2", "tag 3", "tag 4"]
        let withTags = TagListView(viewModel: withTagsViewModel)

        return Group {
            loading.previewDisplayName("loading")
            empty.previewDisplayName("empty")
            withTags.previewDisplayName("with tags")
        }
    }
}
