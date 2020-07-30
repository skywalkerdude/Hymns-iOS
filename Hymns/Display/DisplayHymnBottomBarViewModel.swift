import Combine
import Foundation
import Resolver

class DisplayHymnBottomBarViewModel: ObservableObject {

    /**
     * Threshold for determining if there should be an overflow menu or not
     */
    public static let overflowThreshold = 6

    @Published var buttons: [BottomBarButton]
    @Published var overflowButtons: [BottomBarButton]?

    let identifier: HymnIdentifier

    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository

    private var disposables = Set<AnyCancellable>()

    init(hymnToDisplay identifier: HymnIdentifier,
         analytics: AnalyticsLogger = Resolver.resolve(),
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        self.analytics = analytics
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.repository = repository
        self.backgroundQueue = backgroundQueue
        self.buttons = [BottomBarButton]()
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

                    var buttons = [BottomBarButton]()

                    buttons.append(.share(self.convertToOneString(verses: hymn.lyrics)))

                    buttons.append(.fontSize)

                    let languages = self.convertToSongResults(hymn.languages)
                    if !languages.isEmpty {
                        buttons.append(.languages(languages))
                    }

                    let mp3Path = hymn.music?.data.first(where: { datum -> Bool in
                        datum.value == DatumValue.mp3.rawValue
                    })?.path
                    if let mp3Url = mp3Path.flatMap({ path -> URL? in
                        HymnalNet.url(path: path)
                    }) {
                        buttons.append(.musicPlayback(AudioPlayerViewModel(url: mp3Url)))
                    }

                    let relevant = self.convertToSongResults(hymn.relevant)
                    if !relevant.isEmpty {
                        buttons.append(.relevant(relevant))
                    }

                    buttons.append(.tags)

                    if let url = "https://m.soundcloud.com/search/sounds?q=\(hymn.title)".toEncodedUrl {
                        buttons.append(.soundCloud(url))
                    }

                    if let url = "https://www.youtube.com/results?search_query=\(hymn.title)".toEncodedUrl {
                        buttons.append(.youTube(url))
                    }

                    buttons.append(.songInfo(SongInfoDialogViewModel(hymnToDisplay: self.identifier)))

                    self.buttons = [BottomBarButton]()
                    if buttons.count > Self.overflowThreshold {
                        self.buttons.append(contentsOf: buttons[0..<(Self.overflowThreshold - 1)])
                        var overflowButtons = [BottomBarButton]()
                        overflowButtons.append(contentsOf: buttons[(Self.overflowThreshold - 1)..<buttons.count])
                        self.overflowButtons = overflowButtons
                    } else {
                        self.buttons.append(contentsOf: buttons)
                        self.overflowButtons = nil
                    }
            }).store(in: &disposables)
    }

    private func convertToSongResults(_ option: MetaDatum?) -> [SongResultViewModel] {
        option.map { metaDatum -> [SongResultViewModel] in
            metaDatum.data.compactMap {datum -> SongResultViewModel? in
                guard let hymnType = RegexUtil.getHymnType(path: datum.path), let hymnNumber = RegexUtil.getHymnNumber(path: datum.path) else {
                    self.analytics.logError(message: "error happened when trying to parse song language", extraParameters: ["path": datum.path, "value": datum.value])
                    return nil
                }
                let queryParams = RegexUtil.getQueryParams(path: datum.path)
                let title = datum.value
                let hymnIdentifier = HymnIdentifier(hymnType: hymnType, hymnNumber: hymnNumber, queryParams: queryParams)
                return SongResultViewModel(title: title, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymnIdentifier)).eraseToAnyView())
            }
        }  ?? [SongResultViewModel]()
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
