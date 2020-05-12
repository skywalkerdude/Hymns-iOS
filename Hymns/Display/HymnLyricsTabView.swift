import Foundation
import SwiftUI

/**
 * Custom `TabView` that uses a custom `TabBar` which draws an accented indicator below each tab.
 * Idea for this `TabView` class taken from: https://github.com/innoreq/IRScrollableTabView
 */
public struct HymnLyricsTabView<TabType: HymnLyricsTabItem>: View {

    @Binding var currentTab: TabType
    let tabItems: [TabType]
    @ObservedObject var viewModel: DisplayHymnViewModel

    public var body: some View {
        return
            VStack(alignment: .center) {

                Rectangle()
                    .shadow(radius: 0, y: 0)
                    .frame(height: 50)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .overlay(HymnLyricsTabBar(currentTab: $currentTab, tabItems: tabItems))
                Divider().offset(x: 0.0, y: -3.0).edgesIgnoringSafeArea(.horizontal)

                if self.currentTab.a11yLabel == Text("lyrics") {
                    HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel).padding(.horizontal).eraseToAnyView()
                } else if self.currentTab.a11yLabel == Text("chords") {
                    WebView(url: self.viewModel.chordsUrl!).eraseToAnyView()
                } else if self.currentTab.a11yLabel == Text("guitar") {
                    WebView(url: self.viewModel.guitarUrl!).eraseToAnyView()
                } else if self.currentTab.a11yLabel == Text("piano") {
                    WebView(url: self.viewModel.pianoUrl!).eraseToAnyView()
                } else {
                    Text("Selection is undefined. This should never happen. Please file feedback with a screenshot: hymnalappfeedback@gmail.com").maxSize().eraseToAnyView()
                }
        }
    }
}

struct HymnLyricsTabView_Previews: PreviewProvider {

    static var previews: some View {
        var selectedTab: HymnLyricsTab = .lyrics
        let selectedTabBinding = Binding<HymnLyricsTab>(
            get: {selectedTab},
            set: {selectedTab = $0})
        let tabItems: [HymnLyricsTab] = [
            .lyrics,
            .chords,
            .guitar,
            .piano
        ]

        let classic40ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)

        classic40ViewModel.title = "Hymn 40"
        classic40ViewModel.isFavorited = true
        classic40ViewModel.lyrics = [Verse]()
        classic40ViewModel.chordsUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")
        classic40ViewModel.guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=pdf")
        classic40ViewModel.pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")

        return Group {
            HymnLyricsTabView(currentTab: selectedTabBinding, tabItems: tabItems, viewModel: classic40ViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            HymnLyricsTabView(currentTab: selectedTabBinding, tabItems: tabItems, viewModel: classic40ViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            HymnLyricsTabView(currentTab: selectedTabBinding, tabItems: tabItems, viewModel: classic40ViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
        }
    }
}
