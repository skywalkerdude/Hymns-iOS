import FirebaseAnalytics
import SwiftUI
import Resolver

struct DisplayHymnView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: DisplayHymnViewModel

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            DisplayHymnToolbar(viewModel: viewModel).padding(.top)
            if viewModel.tabItems.count > 1 {
                IndicatorTabView(currentTab: $viewModel.currentTab, tabItems: viewModel.tabItems)
            } else {
                viewModel.currentTab.content
            }
            viewModel.bottomBar.map { viewModel in
                DisplayHymnBottomBar(viewModel: viewModel)
            }
        }.hideNavigationBar()
            .onAppear {
                Analytics.setScreenName("DisplayHymnView", screenClass: "DisplayHymnViewModel")
                self.viewModel.fetchHymn()
        }
    }
}

#if DEBUG
struct DisplayHymnView_Previews: PreviewProvider {
    static var previews: some View {

        let loading = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))

        let classic40ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40ViewModel.title = "Hymn 40"
        classic40ViewModel.isFavorited = true
        let classic40LyricsViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40LyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: classic40_preview.lyrics[0].verseContent),
                                           VerseViewModel(verseLines: classic40_preview.lyrics[1].verseContent),
                                           VerseViewModel(verseNumber: "2", verseLines: classic40_preview.lyrics[2].verseContent),
                                           VerseViewModel(verseNumber: "3", verseLines: classic40_preview.lyrics[3].verseContent),
                                           VerseViewModel(verseNumber: "4", verseLines: classic40_preview.lyrics[4].verseContent)]
        classic40ViewModel.currentTab = .lyrics(HymnLyricsView(viewModel: classic40LyricsViewModel).eraseToAnyView())
        classic40ViewModel.tabItems = [classic40ViewModel.currentTab,
                                       .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")).eraseToAnyView()),
                                       .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=pdf")).eraseToAnyView()),
                                       .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")).eraseToAnyView())]
        let classic40 = DisplayHymnView(viewModel: classic40ViewModel)

        let classic1151ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.title = "Hymn 1151"
        classic1151ViewModel.isFavorited = false
        let classic1151LyricsViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151LyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: classic1151_preview.lyrics[0].verseContent),
                                             VerseViewModel(verseLines: classic1151_preview.lyrics[1].verseContent),
                                             VerseViewModel(verseNumber: "2", verseLines: classic1151_preview.lyrics[2].verseContent),
                                             VerseViewModel(verseNumber: "3", verseLines: classic1151_preview.lyrics[3].verseContent),
                                             VerseViewModel(verseNumber: "4", verseLines: classic1151_preview.lyrics[4].verseContent)]
        classic1151ViewModel.currentTab = .lyrics(HymnLyricsView(viewModel: classic1151LyricsViewModel).maxSize().eraseToAnyView())
        classic1151ViewModel.tabItems = [
            classic1151ViewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")).eraseToAnyView())]
        let classic1151 = DisplayHymnView(viewModel: classic1151ViewModel)

        let classic1151ChordsViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ChordsViewModel.title = "Hymn 1151"
        classic1151ChordsViewModel.isFavorited = false
        classic1151ChordsViewModel.currentTab = .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")).eraseToAnyView())
        classic1151ChordsViewModel.tabItems = [
            .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).maxSize().eraseToAnyView()),
            classic1151ChordsViewModel.currentTab,
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")).eraseToAnyView())]
        let classic1151Chords = DisplayHymnView(viewModel: classic1151ChordsViewModel)

        let classic1151PianoViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151PianoViewModel.title = "Hymn 1151"
        classic1151PianoViewModel.isFavorited = false
        classic1151PianoViewModel.currentTab = .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")).eraseToAnyView())
        classic1151PianoViewModel.tabItems = [
            .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).maxSize().eraseToAnyView()),
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")).eraseToAnyView()),
            classic1151PianoViewModel.currentTab]
        let classic1151Piano = DisplayHymnView(viewModel: classic1151PianoViewModel)

        let classic1334ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334ViewModel.title = "Hymn 1334"
        classic1334ViewModel.isFavorited = true
        let classic1334LyricsViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334LyricsViewModel.lyrics
            = [VerseViewModel(verseNumber: "1", verseLines: classic1334_preview.lyrics[0].verseContent)
        ]
        classic1334ViewModel.currentTab = .lyrics(HymnLyricsView(viewModel: classic1334LyricsViewModel).maxSize().eraseToAnyView())
        classic1334ViewModel.tabItems = [
            classic1334ViewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=gtpdf")).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=pdf")).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=ppdf")).eraseToAnyView())]

        let classic1334 = DisplayHymnView(viewModel: classic1334ViewModel)
        return Group {
            loading.previewDisplayName("loading")
            classic40.previewDisplayName("classic 40")
            classic1151.previewDisplayName("classic 1151")
            classic1151Chords.previewDisplayName("classic 1151 chords")
            classic1151Piano.previewDisplayName("classic 1151 piano")
            classic1334.toPreviews("classic 1334")
        }
    }
}
#endif
