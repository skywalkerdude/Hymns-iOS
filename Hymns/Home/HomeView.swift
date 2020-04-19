import Resolver
import SwiftUI

struct HomeView: View {

    @State var searchText: String = ""
    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Look up any hymn").customTitleLayout().padding(.top)
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

private extension HomeView {
    var searchBar: some View {
        NavigationLink(destination: viewModel.createSearchView()) {
            SearchBar(text: $searchText).disabled(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let homeView =
            HomeView(viewModel: HomeViewModel(recentSongs: [
                PreviewSongResults.hymn1151, PreviewSongResults.joyUnspeakable,
                PreviewSongResults.cupOfChrist, PreviewSongResults.hymn480,
                PreviewSongResults.hymn1334, PreviewSongResults.sinfulPast
            ]))
        return
            Group {
                homeView
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                    .previewDisplayName("iPhone SE")
                homeView
                    .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                    .previewDisplayName("iPhone XS Max")
                homeView
                    .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                    .previewDisplayName("iPad Air 2")
        }
    }
}
