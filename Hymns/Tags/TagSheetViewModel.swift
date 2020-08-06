import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagSheetViewModel: ObservableObject {

    typealias Title = String
    @Published var tagsForHymn = [UiTag]()
    @Published var otherTags = [UiTag]()
    @Published var showNewTagCreation = false

    let tagStore: TagStore
    let identifier: HymnIdentifier
    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository
    private var title: String = ""
    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         tagStore: TagStore = Resolver.resolve()) {
        self.backgroundQueue = backgroundQueue
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.repository = repository
        self.tagStore = tagStore
    }

    func fetchHymn() {
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self, let hymn = hymn, !hymn.computedTitle.isEmpty else {
                        return
                    }
                    self.title = hymn.computedTitle
            }).store(in: &disposables)
    }

    func fetchTags() {
        let tagsForHymn = tagStore.getTagsForHymn(hymnIdentifier: self.identifier)
            .map({ entities -> [UiTag] in
                entities.map { entity -> UiTag in
                    return UiTag(
                        title: entity.tag,
                        color: entity.color)
                }}).replaceError(with: [UiTag]()).eraseToAnyPublisher()
        let uniqueTags = tagStore.getUniqueTags()
            .map({ uiTags -> [UiTag] in
                return uiTags
            }).replaceError(with: [UiTag]()).eraseToAnyPublisher()
        Publishers.CombineLatest(tagsForHymn, uniqueTags)
            .receive(on: mainQueue)
            .sink(receiveValue: { (tagsForHymn, allTags) in
                self.tagsForHymn = tagsForHymn
                self.otherTags = allTags.filter({ tag -> Bool in
                    return !tagsForHymn.contains(tag)
                })
                if self.tagsForHymn.isEmpty || self.otherTags.isEmpty {
                    self.showNewTagCreation = true
                }
            }).store(in: &disposables)
    }

    func addTag(tagTitle: String, tagColor: TagColor) {
        let tag = Tag(hymnIdentifier: self.identifier, songTitle: self.title, tag: tagTitle, color: tagColor)
        self.tagStore.storeTag(tag)
    }

    func deleteTag(tagTitle: String, tagColor: TagColor) {
        let tag = Tag(hymnIdentifier: self.identifier, songTitle: self.title, tag: tagTitle, color: tagColor)
        self.tagStore.deleteTag(tag)
    }
}
