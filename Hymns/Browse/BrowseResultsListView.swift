import SwiftUI

struct BrowseResultsListView: View {

    @Environment(\.presentationMode) var presentationMode
    private let viewModel: BrowseResultsListViewModel

    init(viewModel: BrowseResultsListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                PopView {
                    Image(systemName: "chevron.left").accentColor(.primary)
                }.padding()
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Image(systemName: "chevron.left").accentColor(.primary)
//                }).padding()
                Text(viewModel.title).font(.body).fontWeight(.bold)
                Spacer()
            }
            if viewModel.songResults.isEmpty {
                ErrorView().maxSize()
            } else {
                List(viewModel.songResults) { songResult in
                    PushView(destination: songResult.destinationView) {
                        SongResultView(viewModel: songResult)
                    }
                }
            }
        }.hideNavigationBar()
    }
}

struct BrowseResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let emptyViewModel = BrowseResultsListViewModel(tag: UiTag(title: "Best songs", color: .none))
        let empty = BrowseResultsListView(viewModel: emptyViewModel)

        let resultObjects = [SongResultViewModel(title: "Hymn 114", destinationView: EmptyView().eraseToAnyView()),
                           SongResultViewModel(title: "Cup of Christ", destinationView: EmptyView().eraseToAnyView()),
                           SongResultViewModel(title: "Avengers - Endgame", destinationView: EmptyView().eraseToAnyView())]
        let resultsViewModel = BrowseResultsListViewModel(category: "Experience of Christ")
        resultsViewModel.songResults = resultObjects
        let results = BrowseResultsListView(viewModel: resultsViewModel)

        return Group {
            empty.previewDisplayName("error state")
            results.previewDisplayName("browse results")
        }
    }
}
