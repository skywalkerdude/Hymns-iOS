import Foundation
import Resolver
import SwiftUI

#if DEBUG
struct PreviewSongResults {
    static let hymn1151
        = SongResultViewModel(
            title: "Hymn 1151",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).eraseToAnyView())
    static let joyUnspeakable
        = SongResultViewModel(
            title: "Joy Unspekable",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.joyUnspeakable)).eraseToAnyView())
    static let cupOfChrist
        = SongResultViewModel(
            title: "Cup of Christ",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)).eraseToAnyView())
    static let hymn480
        = SongResultViewModel(
            title: "Hymn 480",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn480)).eraseToAnyView())
    static let sinfulPast
        = SongResultViewModel(
            title: "What about my sinful past?",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.sinfulPast)).eraseToAnyView())
    static let hymn1334
        = SongResultViewModel(
            title: "Hymn 1334",
            destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)).eraseToAnyView())
}
#endif
