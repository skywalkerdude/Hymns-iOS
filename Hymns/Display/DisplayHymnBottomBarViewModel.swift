import Combine
import Foundation
import Resolver

class DisplayHymnBottomBarViewModel: ObservableObject {

    @Published var songInfo: SongInfoDialogViewModel
    @Published var sharablelLyrics = ""

    private var lyrics: [VerseViewModel]? = [VerseViewModel]()
    private let identifier: HymnIdentifier
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier, hymnsRepository repository: HymnsRepository = Resolver.resolve(), mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.identifier = identifier
        self.songInfo = SongInfoDialogViewModel(hymnToDisplay: identifier)
        self.mainQueue = mainQueue
        self.repository = repository
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

    func convertToOneString(verses: [VerseViewModel]) -> String {
        var sharablelLyrics = ""
        for verse in verses {
            for verseLine in verse.verseLines {
                sharablelLyrics += (verseLine.verseText + "\n")
            }
            sharablelLyrics += "\n"
        }
        return sharablelLyrics
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
        self.sharablelLyrics = convertToOneString(verses: verseViewModels)
        return verseViewModels
    }
}

extension DisplayHymnBottomBarViewModel: Equatable {
    static func == (lhs: DisplayHymnBottomBarViewModel, rhs: DisplayHymnBottomBarViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
