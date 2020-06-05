import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagListViewModel: ObservableObject {

    @Published var tags = [SongResultViewModel]()

    let objectWillChange = ObservableObjectPublisher()
    private var notificationToken: NotificationToken?
    private let tagStore: TagStore

    init(tagStore: TagStore = Resolver.resolve()) {
        self.tagStore = tagStore
    }

    deinit {
        notificationToken?.invalidate()
    }

    func fetchTagsByTags(_ tagSelected: String?) {
        let result: Results<TagEntity> = tagStore.querySelectedTags(tagSelected: tagSelected)

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            let displayTitle = tag.songTitle
            return SongResultViewModel(
                title: displayTitle ?? "",
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }

    func fetchUniqueTags() {
        let result: [TagEntity] = tagStore.queryUniqueTags()

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            let displayTitle = tag.tag

            return SongResultViewModel(
                title: displayTitle ?? "",
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }
}

extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
