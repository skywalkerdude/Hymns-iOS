import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagListViewModel: ObservableObject {

    @Published var tags = [SongResultViewModel]()
    @Published var unique = [SongResultViewModel]()

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
            var displayTitle = ""
            //song title is used for TagSubList but tag is used for TagList
            if tagSelected != nil {
                displayTitle = tag.songTitle
                return SongResultViewModel(
                    title: displayTitle,
                    destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
            } else {
                displayTitle = tag.tag
                storeUniqueTags(SongResultViewModel(
                    title: displayTitle,
                    destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView()))
            }

            return SongResultViewModel(
                title: displayTitle,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }
//TODO: Fix this up
    //UNIQUE
    func fetchUniqueTags() {
        let result: [TagEntity] = tagStore.queryUniqueTags()

        notificationToken = result.observe { _ in
            self.objectWillChange.send()
        }

        tags = result.map { (tag) -> SongResultViewModel in
            let identifier = HymnIdentifier(tag.hymnIdentifierEntity)
            var displayTitle = ""
            //song title is used for TagSubList but tag is used for TagList
            if tagSelected != nil {
                displayTitle = tag.songTitle
                return SongResultViewModel(
                    title: displayTitle,
                    destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
            } else {
                displayTitle = tag.tag
                storeUniqueTags(SongResultViewModel(
                    title: displayTitle,
                    destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView()))
            }

            return SongResultViewModel(
                title: displayTitle,
                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
        }
    }

    //Takes all of the fetched hymnTags and stores only the unique tag names for us to iterate through
    func storeUniqueTags(_ taggedHymn: SongResultViewModel) {
        if self.unique.contains(taggedHymn) {
            return
        } else {
            self.unique.append(taggedHymn)
        }
    }
}


extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
