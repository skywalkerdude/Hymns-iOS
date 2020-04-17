import Combine
import Resolver
import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DisplayHymnViewModel: ObservableObject {

    typealias Title = String
    @Published var title: Title = ""
    var hymnLyricsViewModel: HymnLyricsViewModel
    private let identifier: HymnIdentifier
    private let repository: HymnsRepository
    private let mainQueue: DispatchQueue
    @Published var favoritedStatus = false
    @Published var hymnType = ""
    @Published var hymnNumber = ""

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.identifier = identifier
        self.hymnType = identifier.hymnType.abbreviatedValue
        self.hymnNumber = identifier.hymnNumber
        self.repository = repository
        self.mainQueue = mainQueue
        hymnLyricsViewModel = HymnLyricsViewModel(hymnToDisplay: identifier)
    }

    func fetchHymn() {
        favoritedStatus = FavoritedHymn.checkIfFavorite(self.hymnType, self.hymnNumber)
        repository
            .getHymn(hymnIdentifier: identifier)
            .map({ (hymn) -> Title? in
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
                    self?.title = title ?? ""
            }).store(in: &disposables)
    }

    func updateFavorite() {
        if self.favoritedStatus {
            FavoritedHymn.saveFavorite(hymnType: self.hymnType, hymnNumber: self.hymnNumber)
        } else {
            FavoritedHymn.removeFavorite(hymnType: self.hymnType, hymnNumber: self.hymnNumber)
        }
    }

    func toggleFavorited() {
        self.favoritedStatus.toggle()
    }
}
