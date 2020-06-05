import SwiftUI
import Resolver

struct TagListView: View {
    @State var unique = [SongResultViewModel]()
    @ObservedObject private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List(self.unique) { tag in
                NavigationLink(destination: TagSubList(tagSelected: tag)) {
                    SongResultView(viewModel: tag)
                }
            }.resignKeyboardOnDragGesture()
        }.onAppear {
            self.viewModel.fetchTagsByTags(nil)
            //self.viewModel.storeUniqueTags()
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
