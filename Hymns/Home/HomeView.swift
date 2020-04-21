import Resolver
import SwiftUI

struct HomeView: View {

    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.searchActive {
                CustomTitle(title: "Look up any hymn")
            }

            SearchBar(
                searchText: $viewModel.searchParameter,
                searchActive: $viewModel.searchActive,
                placeholderText: "Search by numbers or words")
                .padding(.horizontal)

            viewModel.label.map {
                Text($0).font(.caption).padding(.top).padding(.leading)
            }

            List {
                ForEach(self.viewModel.songResults) { songResult in
                    NavigationLink(destination: songResult.destinationView) {
                        SongResultView(viewModel: songResult)
                    }
                }
            }.resignKeyboardOnDragGesture()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let defaultViewModel = HomeViewModel()

        let recentSongsViewModel = HomeViewModel()
        recentSongsViewModel.label = "Recent hymns"
        recentSongsViewModel.songResults = [PreviewSongResults.cupOfChrist, PreviewSongResults.hymn1151, PreviewSongResults.hymn1334]

        let searchActiveViewModel = HomeViewModel()
        searchActiveViewModel.searchActive = true

        let recentSearchesViewModel = HomeViewModel()
        recentSearchesViewModel.searchActive = true
        recentSearchesViewModel.label = "Recent searches"
        recentSearchesViewModel.songResults = [PreviewSongResults.joyUnspeakable, PreviewSongResults.sinfulPast]

        let searchResults = HomeViewModel()
        searchResults.searchActive = true
        searchResults.searchParameter = "Do you love me?"
        searchResults.songResults = [PreviewSongResults.hymn480, PreviewSongResults.hymn1334, PreviewSongResults.hymn1151]

        return
            Group {
                HomeView(viewModel: defaultViewModel)
                    .previewDisplayName("Default state")
                HomeView(viewModel: recentSongsViewModel)
                    .previewDisplayName("Recent songs")
                HomeView(viewModel: searchActiveViewModel)
                    .previewDisplayName("Active search without recent searches")
                HomeView(viewModel: recentSearchesViewModel)
                    .previewDisplayName("Active search with recent searches")
                HomeView(viewModel: searchResults)
                    .previewDisplayName("Search results")
                HomeView(viewModel: defaultViewModel)
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                    .previewDisplayName("iPhone SE")
                HomeView(viewModel: defaultViewModel)
                    .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                    .previewDisplayName("iPhone XS Max")
                HomeView(viewModel: defaultViewModel)
                    .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                    .previewDisplayName("iPad Air 2")
        }
    }
}
