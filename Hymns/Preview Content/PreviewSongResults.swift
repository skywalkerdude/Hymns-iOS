import Foundation
import Resolver

struct PreviewSongResults {
    static let hymn1151
        = SongResultViewModel(title: "Hymn 1151",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
    static let joyUnspeakable
        = SongResultViewModel(title: "Joy Unspekable",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.joyUnspeakable,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
    static let cupOfChrist
        = SongResultViewModel(title: "Cup of Christ",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
    static let hymn480
        = SongResultViewModel(title: "Hymn 480",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn480,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
    static let sinfulPast
        = SongResultViewModel(title: "What about my sinful past?",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.sinfulPast,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
    static let hymn1334
        = SongResultViewModel(title: "Hymn 1334",
                              destinationView: HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334,
                                                                                             hymnsRepository: Resolver.resolve(),
                                                                                             mainQueue: Resolver.resolve(name: "main"))))
}
