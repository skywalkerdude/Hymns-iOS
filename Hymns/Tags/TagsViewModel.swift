import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagsViewModel: ObservableObject {

    @Published var tags = [SongResultViewModel]()

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore = Resolver.resolve()) {
        self.favoritesStore = favoritesStore
    }

    deinit {
        notificationToken?.invalidate()
    }

    func fetchTagsByTags(_ tagSelected: String?) {
        let result: Results<FavoriteEntity> = favoritesStore.querySelectedTags(tagSelected: tagSelected)

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            var displayTitle = ""

            if tagSelected != nil {
                displayTitle = tag.songTitle
            } else {
                displayTitle = tag.tags
            }

            return SongResultViewModel(
                title: displayTitle,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }

    func fetchTagsByHymn(hymnSelected: HymnIdentifier) {
        let result: Results<FavoriteEntity> = favoritesStore.specificHymn(hymnIdentifier: hymnSelected)

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
        register {TagsViewModel()}.scope(graph)
    }
}
