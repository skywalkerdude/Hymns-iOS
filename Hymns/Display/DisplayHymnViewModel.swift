import Combine
import RealmSwift
import Resolver
import SwiftUI

class DisplayHymnViewModel: ObservableObject {

    typealias Title = String
    typealias Lyrics = [Verse]

    @Published var title: String = ""
    @Published var currentTab: HymnLyricsTab
    @Published var tabItems: [HymnLyricsTab] = [HymnLyricsTab]()
    @Published var isFavorited: Bool?
    @Published var bottomBar: DisplayHymnBottomBarViewModel?

    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let favoritesStore: FavoritesStore
    private let historyStore: HistoryStore
    private let identifier: HymnIdentifier
    private let mainQueue: DispatchQueue
    private let pdfLoader: PDFLoader
    private let repository: HymnsRepository

    private var favoritesObserver: Notification?
    private var disposables = Set<AnyCancellable>()

    init(analytics: AnalyticsLogger = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         favoritesStore: FavoritesStore = Resolver.resolve(),
         hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         historyStore: HistoryStore = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         pdfPreloader: PDFLoader = Resolver.resolve()) {
        self.analytics = analytics
        self.backgroundQueue = backgroundQueue
        self.currentTab = .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: identifier)).maxSize().eraseToAnyView())
        self.favoritesStore = favoritesStore
        self.historyStore = historyStore
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.pdfLoader = pdfPreloader
        self.repository = repository
    }

    deinit {
        favoritesObserver = nil
    }

    func fetchHymn() {
        analytics.logDisplaySong(hymnIdentifier: identifier)
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self else { return }
                    guard let hymn = hymn else { return }

                    let title: Title
                    if self.identifier.hymnType == .classic {
                        title = "Hymn \(self.identifier.hymnNumber)"
                    } else {
                        title = hymn.title.replacingOccurrences(of: "Hymn: ", with: "")
                    }
                    self.title = title

                    self.tabItems = [self.currentTab]

                    let chordsPath = hymn.pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.text.rawValue
                    })?.path
                    let chordsUrl = chordsPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let chordsUrl = chordsUrl {
                        self.pdfLoader.load(url: chordsUrl)
                        self.tabItems.append(.chords(PDFViewer(url: chordsUrl).eraseToAnyView()))
                    }

                    let guitarPath = hymn.pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.guitar.rawValue
                    })?.path
                    let guitarUrl = guitarPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let guitarUrl = guitarUrl {
                        self.pdfLoader.load(url: guitarUrl)
                        self.tabItems.append(.guitar(PDFViewer(url: guitarUrl).eraseToAnyView()))
                    }

                    let pianoPath = hymn.pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.piano.rawValue
                    })?.path
                    let pianoUrl = pianoPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let pianoUrl = pianoUrl {
                        self.pdfLoader.load(url: pianoUrl)
                        self.tabItems.append(.piano(PDFViewer(url: pianoUrl).eraseToAnyView()))
                    }

                    self.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: self.identifier)
                    self.fetchFavoriteStatus()
                    self.historyStore.storeRecentSong(hymnToStore: self.identifier, songTitle: title)
            }).store(in: &disposables)
    }

    func fetchFavoriteStatus() {
        self.isFavorited = favoritesStore.isFavorite(hymnIdentifier: identifier)
        favoritesObserver = favoritesStore.observeFavoriteStatus(hymnIdentifier: identifier) { isFavorited in
            self.isFavorited = isFavorited
        }
    }
    func toggleFavorited() {
        isFavorited.map { isFavorited in
            if isFavorited {
                favoritesStore.deleteFavorite(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: self.identifier))
            } else {
                favoritesStore.storeFavorite(FavoriteEntity(hymnIdentifier: self.identifier, songTitle: self.title))
            }
        }
    }
}
