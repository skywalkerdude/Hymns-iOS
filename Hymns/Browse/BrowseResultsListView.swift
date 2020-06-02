import SwiftUI
import UIKit

struct BrowseResultsListView: View {

    @Environment(\.presentationMode) var presentationMode
    let viewModel: BrowseResultsListViewModel

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left").accentColor(.primary)
                }).padding()
                Text(viewModel.title).font(.body).fontWeight(.bold)
                Spacer()
            }
            List(viewModel.songResults) { songResult in
                NavigationLink(destination: songResult.destinationView) {
                    SongResultView(viewModel: songResult)
                }
            }
        }.hideNavigationBar()
    }
}

struct BrowseResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let songResults = [SongResultViewModel(title: "Hymn 114", destinationView: EmptyView().eraseToAnyView()),
                           SongResultViewModel(title: "Cup of Christ", destinationView: EmptyView().eraseToAnyView()),
                           SongResultViewModel(title: "Avengers - Endgame", destinationView: EmptyView().eraseToAnyView())]
        let viewModel = BrowseResultsListViewModel(category: "Experience of Christ")
        viewModel.songResults = songResults

        return Group {
            BrowseResultsListView(viewModel: viewModel)
        }
    }
}
