import Combine
import FirebaseCrashlytics
import Foundation
import Resolver

class HomeViewModel: ObservableObject {

    @Published var searchActive: Bool = false
    @Published var searchParameter = ""
    @Published var songResults: [SongResultViewModel] = [SongResultViewModel]()
    @Published var label: String?
    @Published var state: HomeResultState = .loading

    private var currentPage = 1
    private var hasMorePages = false
    private var isLoading = false
    private var recentSongsNotification: Notification?

    private var disposables = Set<AnyCancellable>()
    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let historyStore: HistoryStore
    private let mainQueue: DispatchQueue
    private let repository: SongResultsRepository

    init(analytics: AnalyticsLogger = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         historyStore: HistoryStore = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         repository: SongResultsRepository = Resolver.resolve()) {
        self.analytics = analytics
        self.backgroundQueue = backgroundQueue
        self.historyStore = historyStore
        self.mainQueue = mainQueue
        self.repository = repository

        // Initialize HymnDataStore early and start doing the heavy copying work on the background.
        backgroundQueue.async {
            let _: HymnDataStore = Resolver.resolve()
        }

        $searchActive
            .receive(on: mainQueue)
            .sink { searchActive in
                self.analytics.logSearchActive(isActive: searchActive)
                if !searchActive {
                    self.resetState()
                    self.fetchRecentSongs()
                    return
                }
        }.store(in: &disposables)

        $searchParameter
            // Ignore the first call with an empty string since it's take care of already by $searchActive
            .dropFirst()
            // Debounce works by waiting a bit until the user stops typing and before sending a value
            .debounce(for: .seconds(0.3), scheduler: mainQueue)
            .sink { searchParameter in
                self.analytics.logQueryChanged(queryText: searchParameter)
                self.refreshSearchResults()
        }.store(in: &disposables)
    }

    deinit {
        recentSongsNotification?.invalidate()
    }

    private func resetState() {
        currentPage = 1
        hasMorePages = false
        songResults = [SongResultViewModel]()
        state = .loading
    }

    private func refreshSearchResults() {
        // Changes in searchActive are taken care of already by $searchActive
        if !self.searchActive {
            return
        }

        resetState()

        if self.searchParameter.isEmpty {
            self.fetchRecentSongs()
            return
        }

        if searchParameter.trim().isPositiveInteger {
            self.fetchByNumber(hymnNumber: searchParameter.trim())
            return
        }
        self.performSearch(page: currentPage)
    }

    private func fetchRecentSongs() {
        label = nil
        state = .loading
        recentSongsNotification?.invalidate() // invalidate old notification because we're about to create a new one
        recentSongsNotification = historyStore.recentSongs { [weak self] recentSongs in
            guard let self = self else { return }

            if self.searchActive && !self.searchParameter.isEmpty {
                // If the recent songs db changes while recent songs shouldn't be shown (there's an active search going on),
                // we don't want to randomly replace the search results with updated db results.
                return
            }
            self.state = .results
            self.songResults = recentSongs.map { recentSong in
                let identifier = HymnIdentifier(recentSong.hymnIdentifierEntity)
                return SongResultViewModel(title: recentSong.songTitle,
                                           destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier,
                                                                                                            storeInHistoryStore: true)).eraseToAnyView())
            }
            if !self.songResults.isEmpty {
                self.label = "Recent hymns"
            }
        }
    }

    private func fetchByNumber(hymnNumber: String) {
        label = nil
        Just((1...HymnType.classic.maxNumber))
            .subscribe(on: backgroundQueue)
            .map { range -> [SongResultViewModel] in
                guard !hymnNumber.isEmpty else {
                    return [SongResultViewModel]()
                }
                let matchingNumbers = range.map({String($0)}).filter {$0.contains(hymnNumber)}
                return matchingNumbers.map({ number -> SongResultViewModel in
                    let title = "Hymn \(number)"
                    let identifier = HymnIdentifier(hymnType: .classic, hymnNumber: number)
                    let destination = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: identifier, storeInHistoryStore: true)).eraseToAnyView()
                    return SongResultViewModel(title: title, destinationView: destination)
                })
        }.receive(on: mainQueue)
            .sink { songResults in
                if hymnNumber != self.searchParameter.trim() {
                    // search parameter has changed by the time the call completed, so just drop this.
                    return
                }
                self.songResults = songResults
                self.state = songResults.isEmpty ? .empty : .results
        }.store(in: &disposables)
    }

    func loadMore(at songResult: SongResultViewModel) {
        if !shouldLoadMore(songResult) {
            return
        }

        currentPage += 1
        performSearch(page: currentPage)
    }

    private func shouldLoadMore(_ songResult: SongResultViewModel) -> Bool {
        let thresholdMet = songResults.firstIndex(of: songResult) ?? 0 > songResults.count - 5
        return hasMorePages && !isLoading && thresholdMet
    }

    private func performSearch(page: Int) {
        label = nil

        let searchInput = self.searchParameter
        if searchInput.isEmpty {
            Crashlytics.crashlytics().record(error: ErrorType.data(description: "search parameter should never be empty during a song fetch"))
            return
        }

        isLoading = true
        repository
            .search(searchParameter: searchParameter.trim(), pageNumber: page)
            .map({ songResultsPage -> ([SongResultViewModel], Bool) in
                let hasMorePages = songResultsPage.hasMorePages ?? false
                let songResults = songResultsPage.results.map { songResult -> SongResultViewModel in
                    let hymnNumber: DisplayHymnViewModel.Title
                    if songResult.identifier.hymnType == .classic {
                        hymnNumber = "Hymn \(songResult.identifier.hymnNumber): "
                    } else {
                        hymnNumber = ""
                    }
                    return SongResultViewModel(title: "\(hymnNumber)\(songResult.name)",
                                               destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: songResult.identifier,
                                                                                                                storeInHistoryStore: true)).eraseToAnyView())
                }
                return (songResults, hasMorePages)
            })
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveCompletion: { [weak self] state in
                    guard let self = self else { return }

                    if searchInput != self.searchParameter {
                        // search parameter has changed by the time the call completed, so just drop this.
                        return
                    }

                    // Call is completed, so set isLoading to false.
                    self.isLoading = false

                    // If there are no more pages and still no results, then we should show the empty state.
                    if !self.hasMorePages && self.songResults.isEmpty {
                        self.state = .empty
                    }

                    switch state {
                    case .failure:
                        // If a call fails, then we assume there are no more pages to load.
                        self.hasMorePages = false
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] (songResults, hasMorePages) in
                    guard let self = self else { return }
                    if searchInput != self.searchParameter {
                        // search parameter has changed by the time results came back, so just drop this.
                        return
                    }

                    // Filter out duplicates
                    self.songResults.append(contentsOf: songResults.filter({ newViewModel -> Bool in
                        !self.songResults.contains(newViewModel)
                    }))
                    self.hasMorePages = hasMorePages
                    if !self.songResults.isEmpty {
                        self.state = .results
                    }
            }).store(in: &disposables)
    }
}

/**
 * Encapsulates the different state the home screen results page can take.
 */
enum HomeResultState {
    /**
     * Currently displaying results.
     */
    case results

    /**
     * Currently displaying the loading state.
     */
    case loading

    /**
     * Currently displaying an no-results state.
     */
    case empty
}

extension Resolver {
    public static func registerHomeViewModel() {
        register {HomeViewModel()}.scope(graph)
    }
}
