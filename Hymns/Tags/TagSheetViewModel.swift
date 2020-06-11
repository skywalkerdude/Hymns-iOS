import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagSheetViewModel: ObservableObject {

    typealias Title = String
    @Published var tags: [TagMeta]?
    @Published var title: String = ""

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
        tagStore.getTagsForHymn(hymnIdentifier: self.identifier)
            .map({ entities -> [TagMeta] in
                entities.map { entity -> TagMeta in
                    return TagMeta(
                        title: entity.tag,
                        color: entity.tagColor)
                }}).replaceError(with: [TagMeta]())
            .receive(on: mainQueue)
            .sink(receiveValue: { results in
                self.tags = results
            }).store(in: &disposables)
    }

    func addTag(tagName: String, tagColor: TagColor) {
        self.tagStore.storeTag(TagEntity(hymnIdentifier: self.identifier, songTitle: self.title, tag: tagName, tagColor: tagColor))
    }

    func deleteTag(tagTitle: String, tagColor: TagColor) {
        self.tagStore.deleteTag(primaryKey: TagEntity.createPrimaryKey(hymnIdentifier: self.identifier, tag: tagTitle), tag: tagTitle)
    }
}

class TagMeta: Identifiable {

    let title: String
    let color: TagColor

    init(title: String, color: TagColor) {
        self.title = title
        self.color = color
    }
}

extension TagMeta: Hashable {
    static func == (lhs: TagMeta, rhs: TagMeta) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Resolver {
    public static func registerTagSheetViewModel() {
        register {TagSheetViewModel(hymnToDisplay: Resolver.resolve())}.scope(graph)
    }
}
