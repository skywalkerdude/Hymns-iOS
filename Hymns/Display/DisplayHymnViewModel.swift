import Combine
import RealmSwift
import Resolver
import SwiftUI

class DisplayHymnViewModel: ObservableObject {
    let webviewCache = WebViewPreloader()
    
    typealias Title = String
    typealias Lyrics = [Verse]
    
    @Published var title: String = ""
    var hymnLyricsViewModel: HymnLyricsViewModel
    private let backgroundQueue: DispatchQueue
    private let identifier: HymnIdentifier
    private let repository: HymnsRepository
    private let mainQueue: DispatchQueue
    private let favoritesStore: FavoritesStore
    private let historyStore: HistoryStore
    @Published var lyrics: Lyrics?
    @Published var chordsUrl: URL?
    @Published var guitarUrl: URL?
    @Published var pianoUrl: URL?
    @Published var isFavorited: Bool?
    
    private var favoritesObserver: Notification?
    private var disposables = Set<AnyCancellable>()
    
    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         favoritesStore: FavoritesStore = Resolver.resolve(),
         historyStore: HistoryStore = Resolver.resolve()) {
        self.backgroundQueue = backgroundQueue
        self.identifier = identifier
        self.repository = repository
        self.mainQueue = mainQueue
        self.favoritesStore = favoritesStore
        self.historyStore = historyStore
        hymnLyricsViewModel = HymnLyricsViewModel(hymnToDisplay: identifier)
    }
    
    deinit {
        favoritesObserver = nil
    }
    
    func fetchHymn() {
        repository
            .getHymn(identifier)
            .map({ [weak self] hymn -> (Title?, Lyrics?, MetaDatum?) in
                guard let self = self else { return (nil, nil, nil) }
                guard let hymn = hymn else {
                    return (nil, nil, nil)
                }
                if self.identifier.hymnType == .classic {
                    return ("Hymn \(self.identifier.hymnNumber)", hymn.lyrics, hymn.pdfSheet)
                }
                return (hymn.title.replacingOccurrences(of: "Hymn: ", with: ""), hymn.lyrics, hymn.pdfSheet)
            })
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] (title, lyrics, pdfSheet) in
                    guard let self = self else { return }
                    guard let title = title else { return }
                    self.fetchFavoriteStatus()
                    self.title = title
                    self.lyrics = lyrics
                    let chordsPath = pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.text.rawValue
                    })?.path
                    self.chordsUrl = chordsPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let chordsUrl = self.chordsUrl {
                        self.webviewCache.preload(url: chordsUrl)
                    }
                    let guitarPath = pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.guitar.rawValue
                    })?.path
                    self.guitarUrl = guitarPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let guitarUrl = self.guitarUrl {
                        self.webviewCache.preload(url: guitarUrl)
                    }
                    let pianoPath = pdfSheet?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.piano.rawValue
                    })?.path
                    self.pianoUrl = pianoPath.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    })
                    if let pianoUrl = self.pianoUrl {
                        self.webviewCache.preload(url: pianoUrl)
                    }
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
