@testable import Hymns

// swiftlint:disable all
class SongResults{}

let hymn1151_songResult = SongResultViewModel(title: "Hymn 1151",
                                              destinationView:
                                                DisplayHymnContainerView(viewModel: DisplayHymnContainerViewModel(hymnToDisplay: hymn1151_identifier)).eraseToAnyView())
let joyUnspeakable_songResult = SongResultViewModel(title: "Joy Unspekable",
                                                    destinationView:
                                                        DisplayHymnContainerView(
                                                            viewModel: DisplayHymnContainerViewModel(hymnToDisplay: joyUnspeakable_identifier)).eraseToAnyView())
let cupOfChrist_songResult = SongResultViewModel(title: "Cup of Christ",
                                                 destinationView:
                                                    DisplayHymnContainerView(viewModel: DisplayHymnContainerViewModel(hymnToDisplay: cupOfChrist_identifier)).eraseToAnyView())
let hymn480_songResult = SongResultViewModel(title: "Hymn 480",
                                             destinationView:
                                                DisplayHymnContainerView(viewModel: DisplayHymnContainerViewModel(hymnToDisplay: hymn480_identifier)).eraseToAnyView())
let sinfulPast_songResult = SongResultViewModel(title: "What about my sinful past?",
                                                destinationView:
                                                    DisplayHymnContainerView(viewModel: DisplayHymnContainerViewModel(hymnToDisplay: sinfulPast_identifier)).eraseToAnyView())
let hymn1334_songResult = SongResultViewModel(title: "Hymn 1334",
                                              destinationView:
                                                DisplayHymnContainerView(viewModel: DisplayHymnContainerViewModel(hymnToDisplay: hymn1334_identifier)).eraseToAnyView())
