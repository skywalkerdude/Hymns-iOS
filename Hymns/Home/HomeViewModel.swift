import Foundation
import Resolver

class HomeViewModel: ObservableObject {

    @Published var recentSongs: [SongResultViewModel<DetailHymnScreen>] = [SongResultViewModel<DetailHymnScreen>]()

    init(recentSongs: [SongResultViewModel<DetailHymnScreen>]) {
        // TODO fetch recent songs instead of passing it in
        self.recentSongs = recentSongs
    }
}

extension HomeViewModel {
    func createSearchView() -> SearchView {
        SearchView(viewModel: Resolver.resolve())
    }
}

extension Resolver {
    public static func registerHomeViewModel() {
        register {HomeViewModel(recentSongs: [SongResultViewModel<DetailHymnScreen>]())}.scope(graph)
    }
}
