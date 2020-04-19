import Combine
import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {

    @Published var lyrics: [VerseViewModel]? = [VerseViewModel]()

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier, hymnsRepository: HymnsRepository, mainQueue: DispatchQueue) {
        hymnsRepository
            .getHymn(hymnIdentifier: identifier)
            .map({ (hymn) -> [VerseViewModel]? in
                guard let hymn = hymn, !hymn.lyrics.isEmpty else {
                    return nil
                }
                return self.convertToViewModels(verses: hymn.lyrics)
            })
            .receive(on: mainQueue)
            .sink(
                receiveCompletion: { [weak self] state in
                    guard let self = self else { return }
                    switch state {
                    case .failure:
                        self.lyrics = nil
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] lyrics in
                    self?.lyrics = lyrics
            }).store(in: &disposables)
    }
    func convertToViewModels(verses: [Verse]) -> [VerseViewModel] {
        var verseViewModels = [VerseViewModel]()
        var verseNumber = 0
        for verse in verses {
            if verse.verseType == VerseType(rawValue: "chorus") {
                verseViewModels.append(VerseViewModel(verse: verse))
            } else {
                verseNumber += 1
                verseViewModels.append(VerseViewModel(verseNumber: "\(verseNumber)", verse: verse))
            }
        }
        return verseViewModels
    }
}
