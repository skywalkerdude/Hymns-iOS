import Combine
import Foundation
import Resolver
import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DisplayHymnViewModel: ObservableObject {

    typealias Title = String

    @Published var favorited: Bool = false
    @Published var title: Title = ""
    var hymnLyricsViewModel: HymnLyricsViewModel
    private let identifier: HymnIdentifier
    private let repository: HymnsRepository
    private let mainQueue: DispatchQueue

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.identifier = identifier
        self.repository = repository
        self.mainQueue = mainQueue
        hymnLyricsViewModel = HymnLyricsViewModel(hymnToDisplay: identifier)
    }

    func fetchHymn() {
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

    func toggleFavorited() {
        self.favorited.toggle()
    }
}
