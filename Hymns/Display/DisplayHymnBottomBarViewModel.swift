import Combine
import Foundation
import Resolver

class DisplayHymnBottomBarViewModel: ObservableObject {

    @Published var songInfo: SongInfoDialogViewModel
    @Published var shareableLyrics: String = ""
    @Published var mp3Path: URL?

    private let identifier: HymnIdentifier
    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier, hymnsRepository repository: HymnsRepository = Resolver.resolve(), mainQueue: DispatchQueue = Resolver.resolve(name: "main"), backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        self.identifier = identifier
        self.songInfo = SongInfoDialogViewModel(hymnToDisplay: identifier)
        self.mainQueue = mainQueue
        self.repository = repository
        self.backgroundQueue = backgroundQueue
    }

    func fetchHymn() {
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self, let hymn = hymn, !hymn.lyrics.isEmpty else {
                        return
                    }

                    self.shareableLyrics = self.convertToOneString(verses: hymn.lyrics)

                    let mp3Path = hymn.musicJson?.data.first(where: { datum -> Bool in
                         datum.value == DatumValue.mp3.rawValue
                         })?.path
                     self.mp3Path = mp3Path.flatMap({ path -> URL? in
                         HymnalNet.url(path: path)
                     })
            }).store(in: &disposables)
    }

    private func convertToOneString(verses: [Verse]) -> String {
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
