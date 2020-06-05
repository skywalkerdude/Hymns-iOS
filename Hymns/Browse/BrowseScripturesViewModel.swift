import Combine
import Resolver

class BrowseScripturesViewModel: ObservableObject {

    @Published var categories: [CategoryViewModel]? = [CategoryViewModel]()

    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let dataStore: HymnDataStore
    private let hymnType: HymnType?
    private let mainQueue: DispatchQueue

    private var disposables = Set<AnyCancellable>()

    init(hymnType: HymnType?,
         analytics: AnalyticsLogger = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         dataStore: HymnDataStore = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.analytics = analytics
        self.backgroundQueue = backgroundQueue
        self.dataStore = dataStore
        self.hymnType = hymnType
        self.mainQueue = mainQueue
    }

    func fetchScriptureSongs() {
        dataStore.getScriptureSongs()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                // TODO implement
            }).store(in: &disposables)
    }
}
