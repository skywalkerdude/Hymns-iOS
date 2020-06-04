import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagSheetViewModel: ObservableObject {

    typealias Title = String
    @Published var tags = [SongResultViewModel]()
    @Published var title: String = ""

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    let favoritesStore: FavoritesStore
    let identifier: HymnIdentifier
    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository
    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier, favoritesStore: FavoritesStore = Resolver.resolve(), hymnsRepository repository: HymnsRepository = Resolver.resolve(), mainQueue: DispatchQueue = Resolver.resolve(name: "main"), backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        self.identifier = identifier
        self.favoritesStore = favoritesStore
        self.repository = repository
        self.mainQueue = mainQueue
        self.backgroundQueue = backgroundQueue
    }

    deinit {
        notificationToken?.invalidate()
    }

    func fetchHymn() {
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self, let hymn = hymn, !hymn.lyrics.isEmpty else {
                        return
                    }
                    let title: Title
                    if self.identifier.hymnType == .classic {
                        title = "Hymn \(self.identifier.hymnNumber)"
                    } else {
                        title = hymn.title.replacingOccurrences(of: "Hymn: ", with: "")
                    }
                    self.title = title
            }).store(in: &disposables)
    }

    func fetchTagsByHymn() {
        let result: Results<FavoriteEntity> = favoritesStore.specificHymn(hymnIdentifier: self.identifier)

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

    func addTag(tagName: String) {
        self.favoritesStore.storeFavorite(FavoriteEntity(hymnIdentifier: self.identifier, songTitle: self.title, tags: tagName))
        self.fetchTagsByHymn()
    }

    func deleteTag(tagTitle: String) {
        self.favoritesStore.deleteTag(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: self.identifier, tags: tagTitle), tags: tagTitle)
        self.fetchTagsByHymn()
    }
}

extension Resolver {
    public static func registerTagSheetViewModel() {
        register {TagSheetViewModel(hymnToDisplay: Resolver.resolve())}.scope(graph)
    }
}
