import Combine
import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {

    @Published var lyrics: [VerseViewModel]? = [VerseViewModel]()

    private let identifier: HymnIdentifier
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository
   // let position: ScrollPosition
    var bigTitle: BigTitle

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"), bigTitle: BigTitle) {
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.repository = repository
        self.bigTitle = bigTitle
    }

    func fetchLyrics() {
        var latestValue: [VerseViewModel]? = [VerseViewModel]()
        repository
            .getHymn(identifier)
            .map({ [weak self] hymn -> [VerseViewModel]? in
                guard let self = self, let hymn = hymn, !hymn.lyrics.isEmpty else {
                    return nil
                }
                return self.convertToViewModels(verses: hymn.lyrics)
            })
            .receive(on: mainQueue)
            .sink(receiveCompletion: { [weak self] state in
                guard let self = self else { return }
                if state == .finished {
                    // Only display the lyrics if the call is finished and we aren't getting any more values
                    self.lyrics = latestValue
                }
                }, receiveValue: { lyrics in
                    latestValue = lyrics
            }).store(in: &disposables)
    }

    func convertToViewModels(verses: [Verse]) -> [VerseViewModel] {
        var verseViewModels = [VerseViewModel]()
        var verseNumber = 0
        for verse in verses {
            if verse.verseType == .chorus || verse.verseType == .other {
                verseViewModels.append(VerseViewModel(verseLines: verse.verseContent, transliteration: verse.transliteration))
            } else {
                verseNumber += 1
                verseViewModels.append(VerseViewModel(verseNumber: "\(verseNumber)", verseLines: verse.verseContent, transliteration: verse.transliteration))
            }
        }
        return verseViewModels
    }
}
