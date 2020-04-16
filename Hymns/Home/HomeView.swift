import SwiftUI

struct HomeView: View {

    @State var searchText: String = ""
    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Look up any hymn").customTitleLayout()
            searchBar
            List {
                ForEach(self.viewModel.recentSongs) { recentSong in
                    NavigationLink(destination: recentSong.destinationView) {
                        SongResultView(viewModel: recentSong)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return HomeView(viewModel: HomeViewModel(recentSongs: [
            PreviewSongResults.hymn1151, PreviewSongResults.joyUnspeakable,
            PreviewSongResults.cupOfChrist, PreviewSongResults.hymn480,
            PreviewSongResults.hymn1334, PreviewSongResults.sinfulPast
        ]))
    }
}

private extension HomeView {
    var searchBar: some View {
        NavigationLink(destination: viewModel.createSearchView()) {
            SearchBar(text: $searchText).disabled(true)
        }
    }
}
