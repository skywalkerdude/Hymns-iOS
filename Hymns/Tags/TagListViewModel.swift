import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagListViewModel: ObservableObject {

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
}

extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
