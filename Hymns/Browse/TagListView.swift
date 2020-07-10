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
                return GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .center, spacing: 5) {
                            Spacer()
                            Image("empty tag illustration")
                            Text("Create tags by tapping on the").lineLimit(3)
                            HStack {
                                Image(systemName: "tag")
                                Text("icon on any hymn")
                            }
                            Spacer()
                        }.frame(minHeight: geometry.size.height)
                    }
                }.eraseToAnyView()
            }
            return List(tags, id: \.self) { tag in
                PushView(destination: BrowseResultsListView(viewModel: BrowseResultsListViewModel(tag: tag))) {
                    Text(tag.title).tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground)
                }
            }.padding(.top).eraseToAnyView()
        }.onAppear {
            self.viewModel.fetchUniqueTags()
        }.background(Color(.systemBackground))
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {

        let loadingViewModel = TagListViewModel()
        let loading = TagListView(viewModel: loadingViewModel)

        let emptyViewModel = TagListViewModel()
        emptyViewModel.tags = [UiTag]()
        let empty = TagListView(viewModel: emptyViewModel)

        let withTagsViewModel = TagListViewModel()
        withTagsViewModel.tags = [UiTag(title: "tag 1", color: .blue),
                                  UiTag(title: "tag 2", color: .green),
                                  UiTag(title: "tag 3", color: .none)]
        let withTags = TagListView(viewModel: withTagsViewModel)

        return Group {
            loading.previewDisplayName("loading")
            empty.previewDisplayName("empty")
            withTags.previewDisplayName("with tags")
        }
    }
}
