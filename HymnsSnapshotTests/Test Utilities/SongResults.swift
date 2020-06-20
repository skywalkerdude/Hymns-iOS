@testable import Hymns

// swiftlint:disable all
class SongResults{}

let hymn1151_songResult = SongResultViewModel(title: "Hymn 1151",
                                              destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)).eraseToAnyView())
let joyUnspeakable_songResult = SongResultViewModel(title: "Joy Unspekable",
                                                    destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: joyUnspeakable_identifier)).eraseToAnyView())
let cupOfChrist_songResult = SongResultViewModel(title: "Cup of Christ",
                                                 destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: cupOfChrist_identifier)).eraseToAnyView())
let hymn480_songResult = SongResultViewModel(title: "Hymn 480",
                                             destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymn480_identifier)).eraseToAnyView())
let sinfulPast_songResult = SongResultViewModel(title: "What about my sinful past?",
                                                destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: sinfulPast_identifier)).eraseToAnyView())
let hymn1334_songResult = SongResultViewModel(title: "Hymn 1334",
                                              destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymn1334_identifier)).eraseToAnyView())
