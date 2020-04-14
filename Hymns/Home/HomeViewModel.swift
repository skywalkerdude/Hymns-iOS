import Foundation
import Resolver

class HomeViewModel: ObservableObject {

    @Published var recentSongs: [SongResultViewModel] = [SongResultViewModel]()

    init(recentSongs: [SongResultViewModel]) {
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
        register {HomeViewModel(recentSongs: [SongResultViewModel]())}.scope(graph)
    }
}
