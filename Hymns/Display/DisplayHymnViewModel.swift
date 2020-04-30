import Combine
import RealmSwift
import Resolver
import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DisplayHymnViewModel: ObservableObject, Identifiable {

    @Published var title: String = ""
    var hymnLyricsViewModel: HymnLyricsViewModel
    private let identifier: HymnIdentifier
    private let repository: HymnsRepository
    private let mainQueue: DispatchQueue
    private let favoritesStore: FavoritesStore
    private let historyStore: HistoryStore
    @Published var isFavorited: Bool?

    @Published var isLoaded: Bool = false

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
            .getHymn(hymnIdentifier: identifier)
            .map({ (hymn) -> String? in
                guard let hymn = hymn else {
                    return nil
                }

                if self.identifier.hymnType == .classic {
                    return "Hymn \(self.identifier.hymnNumber)"
                }
                let title = hymn.title.replacingOccurrences(of: "Hymn: ", with: "")
                return title
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

    func fetchFavoriteStatus() {
        self.isFavorited = favoritesStore.isFavorite(hymnIdentifier: identifier)
        $isLoaded
            .receive(on: mainQueue)
            .sink { isLoaded in
                if isLoaded {
                    if self.favoritesObserver == nil {
                        self.favoritesObserver = self.favoritesStore.observeFavoriteStatus(hymnIdentifier: self.identifier) { isFavorited in
                            self.isFavorited = isFavorited
                        }
                    }
                } else {
                    self.favoritesObserver?.invalidate()
                    self.favoritesObserver = nil
                }
        }.store(in: &disposables)
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
