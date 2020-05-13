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
        VStack(spacing: 15) {
            DisplayHymnToolbar(viewModel: viewModel)
            if viewModel.tabItems.count > 1 {
                IndicatorTabView(currentTab: $viewModel.currentTab, tabItems: viewModel.tabItems)
            } else {
                viewModel.currentTab.content
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
        let classic40Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)

        classic40ViewModel.currentTab = .chords(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")).eraseToAnyView())
        classic40ViewModel.tabItems = [.lyrics(HymnLyricsView(viewModel: classic40Lyrics).eraseToAnyView()),
                                       classic40ViewModel.currentTab,
                                       .guitar(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=pdf")).eraseToAnyView()),
                                       .piano(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")).eraseToAnyView())]
        let classic40 = DisplayHymnView(viewModel: classic40ViewModel)

        let classic1151ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.title = "Hymn 1151"
        classic1151ViewModel.isFavorited = false
        let classic1151Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)

        classic1151ViewModel.currentTab = .lyrics(HymnLyricsView(viewModel: classic1151Lyrics).maxSize().eraseToAnyView())

        classic1151ViewModel.tabItems = [
            classic1151ViewModel.currentTab,
            .chords(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")).eraseToAnyView()),
            .guitar(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")).eraseToAnyView()),
            .piano(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")).eraseToAnyView())]

        let classic1151 = DisplayHymnView(viewModel: classic1151ViewModel)
        let classic1334ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334ViewModel.title = "Hymn 1334"
        classic1334ViewModel.isFavorited = true
        let classic1334Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)

        classic1334ViewModel.currentTab = .lyrics(HymnLyricsView(viewModel: classic1334Lyrics).maxSize().eraseToAnyView())

        classic1334ViewModel.tabItems = [
            classic1334ViewModel.currentTab,
            .chords(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=gtpdf")).eraseToAnyView()),
            .guitar(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=pdf")).eraseToAnyView()),
            .piano(WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=ppdf")).eraseToAnyView())]

        let classic1334 = DisplayHymnView(viewModel: classic1334ViewModel)
        return Group {
            loading.previewDisplayName("loading")
            classic40.previewDisplayName("classic 40")
            classic1151.previewDisplayName("classic 1151")
            classic1334.previewDisplayName("classic 1334")
        }
    }
}
#endif
