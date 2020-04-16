import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DisplayHymnViewModel: ObservableObject {

    @Published var favorited: Bool = false
    var hymnLyricsViewModel: HymnLyricsViewModel

    init(hymnToDisplay hymnIdentifier: HymnIdentifier) {
        hymnLyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymnIdentifier)
    }

    func toggleFavorited() {
        self.favorited.toggle()
    }
}
