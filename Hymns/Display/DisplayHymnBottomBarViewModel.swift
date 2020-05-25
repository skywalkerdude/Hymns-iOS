import Combine
import Foundation
import Resolver

class DisplayHymnBottomBarViewModel: ObservableObject {

    @Published var songInfo: SongInfoDialogViewModel
    @Published var shareableLyrics: String = ""

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
        var latestValue: String = ""
        repository
            .getHymn(identifier)
            .map({ [weak self] hymn -> String in
                guard let self = self, let hymn = hymn, !hymn.lyrics.isEmpty else {
                    return ""
                }
                return self.convertToOneString(verses: hymn.lyrics)
            })
            .receive(on: mainQueue)
            .sink(receiveCompletion: { [weak self] state in
                guard let self = self else { return }
                if state == .finished {
                    // Only display the lyrics if the call is finished and we aren't getting any more values
                    self.shareableLyrics = latestValue
                }
                }, receiveValue: { lyrics in
                    latestValue = lyrics
            }).store(in: &disposables)
    }

    func convertToOneString(verses: [Verse]) -> String {
        var shareableLyrics = ""
        for verse in verses {
            for verseLine in verse.verseContent {
                shareableLyrics += (verseLine + "\n")
            }
            shareableLyrics += "\n"
        }
        return shareableLyrics
    }
}

extension DisplayHymnBottomBarViewModel: Equatable {
    static func == (lhs: DisplayHymnBottomBarViewModel, rhs: DisplayHymnBottomBarViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
