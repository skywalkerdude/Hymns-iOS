import Combine
import SwiftUI
import RealmSwift
import Resolver

class FavoritesViewModel: ObservableObject {

    @Published var favorites = [SongResultViewModel]()

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    private let tagStore: TagStore

    init(tagStore: TagStore = Resolver.resolve()) {
        self.tagStore = tagStore
    }

    deinit {
        notificationToken?.invalidate()
    }

    func fetchFavorites() {
        let result: Results<FavoriteEntity> = tagStore.favorites()

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
}

extension Resolver {
    public static func registerFavoritesViewModel() {
        register {FavoritesViewModel()}.scope(graph)
    }
}
