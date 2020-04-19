import Combine
import Foundation
import Resolver

class SearchViewModel: ObservableObject {

    @Published var songResults: [SongResultViewModel] = [SongResultViewModel]()
    @Published var searchInput = ""

    private let mainQueue: DispatchQueue
    private let repository: SongResultsRepository

    private var disposables = Set<AnyCancellable>()

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         repository: SongResultsRepository = Resolver.resolve()) {
        self.mainQueue = mainQueue
        self.repository = repository

        // TODO fetch recent searches if searchInput is ""
        $searchInput
            // As soon as we create the observation, $searchInput will emit an empty string, do we skip it to avoid an unintended network call.
            .dropFirst(1)
            // Debounce works by waiting half a second (0.5) until the user stops typing and finally sending a value
            .debounce(for: .seconds(0.5), scheduler: backgroundQueue)
            .sink(receiveValue: performSearch(searchInput:))
            .store(in: &disposables)
    }

    private func performSearch(searchInput: String) {
        repository
            .search(searchInput: searchInput, pageNumber: 1)
            .map({ (songResultsPage) -> [SongResultViewModel] in
                guard let songResultsPage = songResultsPage else {
                    return [SongResultViewModel]()
                }
                return songResultsPage.results.compactMap { (songResult) -> SongResultViewModel? in
                    guard let hymnType = RegexUtil.getHymnType(path: songResult.path), let hymnNumber = RegexUtil.getHymnNumber(path: songResult.path) else {
                        // TODO log non fatal
                        return nil
                    }
                    let identifier = HymnIdentifier(hymnType: hymnType, hymnNumber: hymnNumber)
                    return SongResultViewModel(title: songResult.name, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
                }
            }).receive(on: mainQueue)
            .sink(
                receiveCompletion: { [weak self] state in
                    guard let self = self else { return }
                    switch state {
                    case .failure:
                        self.songResults = [SongResultViewModel]()
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] songResults in
                    self?.songResults = songResults
            }).store(in: &disposables)
    }
}

extension Resolver {
    public static func registerSearchViewModel() {
        register {SearchViewModel()}.scope(graph)
    }
}
