import FirebaseAnalytics
import Resolver
import SwiftUI

struct HomeView: View {

    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
        // dummy comment for swiftlint
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.searchActive {
                CustomTitle(title: "Look up any hymn").transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }

            SearchBar(
                searchText: $viewModel.searchParameter,
                searchActive: $viewModel.searchActive,
                placeholderText: "Search by numbers or words")
                .padding(.horizontal)
                .padding(.top, viewModel.searchActive ? nil : .zero)

            viewModel.label.map {
                Text($0).fontWeight(.bold).padding(.top).padding(.leading).foregroundColor(Color("darkModeSubtitle"))
            }

            if viewModel.state == .loading {
                ActivityIndicator().maxSize()
            } else if viewModel.state == .empty {
                Text("Did not find any songs matching:\n\"\(viewModel.searchParameter)\".\nPlease try a different request").padding().multilineTextAlignment(.center).maxSize(alignment: .center)
            } else {
                List(viewModel.songResults) { songResult in
                    NavigationLink(destination: songResult.destinationView) {
                        SongResultView(viewModel: songResult)
                    }.onAppear {
                        self.viewModel.loadMore(at: songResult)
                    }
                }.resignKeyboardOnDragGesture()
            }
        }.onAppear {
            Analytics.setScreenName("HomeView", screenClass: "HomeViewModel")
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let defaultViewModel = HomeViewModel()

        let recentSongsViewModel = HomeViewModel()
        recentSongsViewModel.label = "Recent hymns"
        recentSongsViewModel.songResults = [PreviewSongResults.cupOfChrist, PreviewSongResults.hymn1151, PreviewSongResults.hymn1334]

        let searchActiveViewModel = HomeViewModel()
        searchActiveViewModel.searchActive = true

        let loadingViewModel = HomeViewModel()
        loadingViewModel.state = .loading
        loadingViewModel.searchActive = true
        loadingViewModel.searchParameter = "She loves me not"

        let searchResults = HomeViewModel()
        searchResults.searchActive = true
        searchResults.searchParameter = "Do you love me?"
        searchResults.songResults = [PreviewSongResults.hymn480, PreviewSongResults.hymn1334, PreviewSongResults.hymn1151]

        let noResultsViewModel = HomeViewModel()
        noResultsViewModel.state = .empty
        noResultsViewModel.searchActive = true
        noResultsViewModel.searchParameter = "She loves me not"

        return
            Group {
                HomeView(viewModel: defaultViewModel)
                    .previewDisplayName("Default state")
                HomeView(viewModel: recentSongsViewModel)
                    .previewDisplayName("Recent songs")
                HomeView(viewModel: searchActiveViewModel)
                    .previewDisplayName("Active search without recent searches")
                HomeView(viewModel: loadingViewModel)
                    .previewDisplayName("Active search loading")
                HomeView(viewModel: searchResults)
                    .previewDisplayName("Search results")
                HomeView(viewModel: noResultsViewModel)
                    .previewDisplayName("No results")
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
#endif
