import Combine
import Foundation
import Resolver
import SwiftUI

//This view model will expose 4 other view models to be passed through detailhymnscreen to their respective views. HymnLyricsViewModel, GuitarViewModel, PianoViewModel, and ChordsView Model
//ex. HymnLyricsViewModel -> DetailHymnScreenViewModel -> DetailHymnScreen -> HymnLyricsView
class DetailHymnScreenViewModel: ObservableObject {
    @Published var favorited: Bool = false
    @ObservedObject var hymnLyricsVM: HymnLyricsViewModel // Pass through to Hymn Lyrics View

    init(hymnLyricsVM: HymnLyricsViewModel) {
        self.hymnLyricsVM = hymnLyricsVM
    }

    func toggleFavorited() {
        self.favorited.toggle()
    }
}
