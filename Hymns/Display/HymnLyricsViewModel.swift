import Combine
import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {

    @Published var lyrics: [VerseViewModel]? = [VerseViewModel]()
    @Published var showTransliterationButton = false

    private let identifier: HymnIdentifier
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.repository = repository
    }

    func fetchLyrics() {
        var latestValue: [VerseViewModel]? = [VerseViewModel]()
        var showTransliterationButton = false
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
                    self.showTransliterationButton = showTransliterationButton
                }
                }, receiveValue: { [weak self ] lyrics in
                    guard let self = self else { return }
                    latestValue = lyrics
                    showTransliterationButton = self.containsTransliteration(viewModels: lyrics)
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

    private func containsTransliteration(viewModels: [VerseViewModel]?) -> Bool {
        guard
            let viewModels = viewModels,
            let firstViewModel = viewModels.first,
            let firstLine = firstViewModel.verseLines.first else {
                return false
        }
        return firstLine.transliteration != nil
    }
}
