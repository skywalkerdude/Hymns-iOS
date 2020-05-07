import Combine
import RealmSwift
import Resolver
import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DisplayHymnViewModel: ObservableObject {

    @Published var title: String = ""
    var hymnLyricsViewModel: HymnLyricsViewModel
    let identifier: HymnIdentifier
    private let repository: HymnsRepository
    private let mainQueue: DispatchQueue
    private let favoritesStore: FavoritesStore
    private let historyStore: HistoryStore
    @Published var musicPath: String = ""
    @Published var isFavorited: Bool?

    private var favoritesObserver: Notification?
    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         favoritesStore: FavoritesStore = Resolver.resolve(),
         historyStore: HistoryStore = Resolver.resolve()) {
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
            .map({ [weak self] hymn -> String? in
                guard let self = self else { return nil }
                if self.identifier.hymnType == .classic {
                    return "Hymn \(self.identifier.hymnNumber)"
                }
                guard let hymn = hymn else {
                    return nil
                }
                return hymn.title.replacingOccurrences(of: "Hymn: ", with: "")
            })
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] title in
                    guard let self = self else { return }
                    guard let title = title else { return }
                    self.fetchFavoriteStatus()
                    self.title = title
                    self.historyStore.storeRecentSong(hymnToStore: self.identifier, songTitle: title)
            }).store(in: &disposables)
    }

    func fetchHymnChords() {
        repository
            .getHymn(identifier)
            .map({ hymn -> String? in
                guard let hymn = hymn else {
                    return nil
                }

                let trimFront = hymn.pdfSheetJson.components(separatedBy: "path\":\"")
                let trimmedPath = trimFront[1].components(separatedBy: "f=ppdf")
                return trimmedPath[0]
            })
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] pdfSheetJson in
                    guard let self = self else { return }
                    guard let pdfSheetJson = pdfSheetJson else { return }
                    self.musicPath = pdfSheetJson
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
