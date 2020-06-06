import Combine
import Foundation
import Resolver

class BrowseResultsListViewModel: ObservableObject {

    @Published var title: String
    @Published var songResults = [SongResultViewModel]()

    private var disposables = Set<AnyCancellable>()

    init(tag: String, tagStore: TagStore = Resolver.resolve()) {
        self.title = tag
        songResults = tagStore.getSongsByTag(tag)
    }

    init(category: String, subcategory: String? = nil,
         hymnType: HymnType? = nil, dataStore: HymnDataStore = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {

        if let subcategory = subcategory {
            self.title = subcategory
        } else {
            self.title = category
        }

        dataStore.getResultsBy(category: category, hymnType: hymnType, subcategory: subcategory)
            .subscribe(on: backgroundQueue)
            .map({ songResults -> [SongResultViewModel] in
                songResults.map { songResult -> SongResultViewModel in
                    let hymnIdentifier = HymnIdentifier(hymnType: songResult.hymnType, hymnNumber: songResult.hymnNumber, queryParams: songResult.queryParams)
                    let title = songResult.title.replacingOccurrences(of: "Hymn: ", with: "")
                    return SongResultViewModel(title: title, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymnIdentifier)).eraseToAnyView())
                }
            })
            .receive(on: mainQueue)
            .replaceError(with: [SongResultViewModel]())
            .sink(receiveValue: { [weak self] viewModels in
                guard let self = self else { return }
                self.songResults = viewModels
            }).store(in: &disposables)
    }
}
