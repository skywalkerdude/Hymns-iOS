import SwiftUI

struct DisplayHymnLyricsBar: View {

    @ObservedObject private var viewModel: DisplayHymnViewModel
    @State var selectedTab: HymnLyricsTab = .lyrics

    @Binding var currentLyricsTab: HymnLyricsTab

    init(viewModel: DisplayHymnViewModel, currentLyricsTab: Binding<HymnLyricsTab>) {
        self.viewModel = viewModel
        self._currentLyricsTab = currentLyricsTab
    }

    var body: some View {
        HStack {
            IndicatorTabView(currentTab: $selectedTab, tabItems: [
                .lyrics,
                .chords,
                .guitar,
                .piano
            ], viewModel: self.viewModel)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#if DEBUG
struct DisplayHymnLyricsBar_Previews: PreviewProvider {
    static var previews: some View {
        var currentTabLyrics: HymnLyricsTab = .lyrics
        let currentTabLyricsBinding = Binding<HymnLyricsTab>(
            get: {currentTabLyrics},
            set: {currentTabLyrics = $0})

        let loading = DisplayHymnLyricsBar(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151), currentLyricsTab: currentTabLyricsBinding)

        let onlyLyricsViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        onlyLyricsViewModel.lyrics = [Verse]()
        let onlyLyrics = DisplayHymnLyricsBar(viewModel: onlyLyricsViewModel, currentLyricsTab: currentTabLyricsBinding)

        var currentTabGuitar: HymnLyricsTab = .guitar
        let currentTabGuitarBinding = Binding<HymnLyricsTab>(
            get: {currentTabGuitar},
            set: {currentTabGuitar = $0})
        let missingChordsViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        missingChordsViewModel.lyrics = [Verse]()
        missingChordsViewModel.guitarUrl = URL(string: "http://www.google.com")
        missingChordsViewModel.pianoUrl = URL(string: "http://www.google.com")
        let missingChords = DisplayHymnLyricsBar(viewModel: missingChordsViewModel, currentLyricsTab: currentTabGuitarBinding)

        let allMusicViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        allMusicViewModel.lyrics = [Verse]()
        allMusicViewModel.chordsUrl = URL(string: "http://www.google.com")
        allMusicViewModel.guitarUrl = URL(string: "http://www.google.com")
        allMusicViewModel.pianoUrl = URL(string: "http://www.google.com")
        let allMusic = DisplayHymnLyricsBar(viewModel: allMusicViewModel, currentLyricsTab: currentTabGuitarBinding)
        return Group {
            loading.previewDisplayName("loading")
            onlyLyrics.previewDisplayName("only lyrics")
            missingChords.previewDisplayName("missing chords")
            allMusic.previewDisplayName("all music available")
        }.previewLayout(.fixed(width: 450, height: 50))
    }
}
#endif
