import Combine
import SwiftUI
import RealmSwift
import Resolver

class SelfTags: Identifiable {

    let title: String
    let color: TagColor

    init(title: String, color: TagColor) {
        self.title = title
        self.color = color
    }
}

extension SelfTags: Hashable {
    static func == (lhs: SelfTags, rhs: SelfTags) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

class TagSheetViewModel: ObservableObject {

    typealias Title = String
    @Published var tags = [SelfTags]()
    @Published var title: String = ""

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    let tagStore: TagStore
    let identifier: HymnIdentifier
    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository
    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier, tagStore: TagStore = Resolver.resolve(), hymnsRepository repository: HymnsRepository = Resolver.resolve(), mainQueue: DispatchQueue = Resolver.resolve(name: "main"), backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        self.identifier = identifier
        self.tagStore = tagStore
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
        let result = tagStore.getTagsForHymn(hymnIdentifier: self.identifier)

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

//        (waka) = result.reduce(into: [Tagger]()) {
//            waka.append(Tagger(tagName: $1.tagName, tagColor: $1.tagColor))
//
//     //       $0.0.append($1.tagName)
//  //          $0.1.append($1.tagColor)
//        }

        tags = result.map { (tag) -> SelfTags in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            return SelfTags(
                title: tag.tag,
                color: tag.tagColor)
        }
    }

//    func fetchFavorites() {
//        let result: Results<FavoriteEntity> = favoriteStore.favorites()
//
//        notificationToken = result.observe { _ in
//            self.objectWillChange.send()
//        }
//
//        favorites = result.map { (favorite) -> SongResultViewModel in
//            let identifier = HymnIdentifier(favorite.hymnIdentifierEntity)
//            return SongResultViewModel(
//                title: favorite.songTitle,
//                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
//        }
//    }




    func addTag(tagName: String, tagColor: TagColor) {
        self.tagStore.storeTag(TagEntity(hymnIdentifier: self.identifier, songTitle: self.title, tag: tagName, tagColor: tagColor))
        self.fetchTagsByHymn()
    }

    func deleteTag(tagTitle: String, tagColor: TagColor) {
        self.tagStore.deleteTag(primaryKey: TagEntity.createPrimaryKey(hymnIdentifier: self.identifier, tag: tagTitle), tag: tagTitle)
        self.fetchTagsByHymn()
    }
}

extension Resolver {
    public static func registerTagSheetViewModel() {
        register {TagSheetViewModel(hymnToDisplay: Resolver.resolve())}.scope(graph)
    }
}
