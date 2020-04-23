import Combine
import Foundation
import RealmSwift
import Resolver

class HomeViewModel: ObservableObject {

    @Published var searchActive: Bool = false
    @Published var searchParameter = ""
    @Published var songResults: [SongResultViewModel] = [SongResultViewModel]()
    @Published var label: String?

    private var recentSongsNotification: NotificationToken?

    private var disposables = Set<AnyCancellable>()
    private let historyStore: HistoryStore
    private let mainQueue: DispatchQueue
    private let repository: SongResultsRepository

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         historyStore: HistoryStore = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         repository: SongResultsRepository = Resolver.resolve()) {
        self.historyStore = historyStore
        self.mainQueue = mainQueue
        self.repository = repository

        $searchActive
            .receive(on: mainQueue)
            .sink { searchActive in
                if !searchActive {
                    self.fetchRecentSongs()
                    return
                }
                if self.searchParameter.isEmpty {
                    self.fetchRecentSearches()
                    return
                }
                self.label = nil
        }.store(in: &disposables)

        $searchParameter
            .dropFirst()
            // Debounce works by waiting a bit until the user stops typing and before sending a value
            .debounce(for: .seconds(0.5), scheduler: backgroundQueue)
            .receive(on: mainQueue)
            .sink { searchParameter in
                if !self.searchActive {
                    return
                }
                if searchParameter.isEmpty {
                    self.fetchRecentSearches()
                    return
                }
                self.performSearch(searchParameter: searchParameter)
        }.store(in: &disposables)
    }

    deinit {
        recentSongsNotification?.invalidate()
    }

    private func fetchRecentSongs() {
        label = "Recent hymns"
        recentSongsNotification = historyStore.recentSongs { recentSongs in
            self.songResults = recentSongs.map { recentSong in
                let identifier = HymnIdentifier(recentSong.hymnIdentifierEntity)
                return SongResultViewModel(title: recentSong.songTitle, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier)).eraseToAnyView())
            }
        }
    }

    private func fetchRecentSearches() {
        songResults = [PreviewSongResults.joyUnspeakable, PreviewSongResults.sinfulPast]
        label = "Recent searches"
    }

    private func performSearch(searchParameter: String) {
        songResults = [SongResultViewModel]()
        label = nil
        repository
            .search(searchParameter: searchParameter, pageNumber: 1)
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
    public static func registerHomeViewModel() {
        register {HomeViewModel()}.scope(graph)
    }
}
