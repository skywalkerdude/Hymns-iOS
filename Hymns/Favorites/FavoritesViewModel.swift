import Combine
import SwiftUI
import RealmSwift
import Resolver

class FavoritesViewModel: ObservableObject {

    @Published var favorites = [SongResultViewModel]()
    @Published var tags = [SongResultViewModel]()
    @Published var tagNames = [String]()

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore = Resolver.resolve()) {
        self.favoritesStore = favoritesStore
    }

    deinit {
        notificationToken?.invalidate()
    }

    func fetchFavorites() {
        let result: Results<FavoriteEntity> = favoritesStore.favorites()

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        favorites = result.map { (favorite) -> SongResultViewModel in
            let identifier = HymnIdentifier(favorite.hymnIdentifierEntity)
            return SongResultViewModel(
                title: favorite.songTitle,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }

    func fetchTags(_ tagSelected: String) {
        print("bbug fetch tag called")
        let result: Results<FavoriteEntity> = favoritesStore.specificTag(tagSelected)

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            return SongResultViewModel(
                title: tag.songTitle,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }

    func fetchTagsName() {
        print("bbug fetch tag called")
        let result: Results<FavoriteEntity> = favoritesStore.tags()

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            return SongResultViewModel(
                title: tag.tags,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }
}


extension Resolver {
    public static func registerFavoritesViewModel() {
        register {FavoritesViewModel()}.scope(graph)
    }
}
