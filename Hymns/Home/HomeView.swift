import Resolver
import SwiftUI

struct HomeView: View {

    @Binding var searchActive: Bool
    @Binding var searchInput: String
    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
        self.searchActive = viewModel.$searchActive
        self.searchInput = viewModel.$searchInput
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !searchActive {
                CustomTitle(title: "Look up any hymn")
            }

            SearchBar(
                searchText: $searchText,
                searchActive: $searchActive,
                placeholderText: "Search by numbers or words")
                .padding(.horizontal)

            (searchActive ? Text("Recent searches") : Text("Recent hymns")).font(.caption).padding(.top).padding(.leading)

            List {
                ForEach(self.viewModel.recentSongs) { recentSong in
                    NavigationLink(destination: recentSong.destinationView) {
                        SongResultView(viewModel: recentSong)
                    }
                }
            }.resignKeyboardOnDragGesture()
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
