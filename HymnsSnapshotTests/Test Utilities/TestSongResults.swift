import Foundation
import Resolver
@testable import Hymns

// swiftlint:disable all

class TestSongResults{}

let hymn1151 = SongResultViewModel(title: "Hymn 1151",
                                   destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).eraseToAnyView())
let joyUnspeakable = SongResultViewModel(title: "Joy Unspekable",
                                         destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.joyUnspeakable)).eraseToAnyView())
let cupOfChrist = SongResultViewModel(title: "Cup of Christ",
                                      destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)).eraseToAnyView())
let hymn480 = SongResultViewModel(title: "Hymn 480",
                                  destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn480)).eraseToAnyView())
let sinfulPast = SongResultViewModel(title: "What about my sinful past?",
                                     destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.sinfulPast)).eraseToAnyView())
let hymn1334 = SongResultViewModel(title: "Hymn 1334",
                                   destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)).eraseToAnyView())
