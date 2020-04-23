import SwiftUI
import RealmSwift
import Resolver

class FavoritesViewModel: ObservableObject {

    @Published var favorites: LazyMapSequence<Results<FavoriteEntity>, SongResultViewModel>?

    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore = Resolver.resolve()) {
        self.favoritesStore = favoritesStore
    }

    func fetchFavorites() {
        favorites = favoritesStore.favorites().map { (favorite) -> SongResultViewModel in
            let identifier = HymnIdentifier(favorite.hymnIdentifierEntity)
            return SongResultViewModel(title: favorite.songTitle, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }
}

extension Resolver {
    public static func registerFavoritesViewModel() {
        register {FavoritesViewModel()}.scope(graph)
    }
}
