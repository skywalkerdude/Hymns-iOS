import Foundation
import SwiftUI

/**
 * Custom `TabView` that uses a custom `TabBar` which draws an accented indicator below each tab.
 * Idea for this `TabView` class taken from: https://github.com/innoreq/IRScrollableTabView
 */
public struct IndicatorTabView<TabType: TabItem>: View {
    @Binding private var currentTab: TabType
    private let tabItems: [TabType]
    private let tabAlignment: TabAlignment

    init(currentTab: Binding<TabType>, tabItems: [TabType], tabAlignment: TabAlignment = .top) {
        self._currentTab = currentTab
        self.tabItems = tabItems
        self.tabAlignment = tabAlignment
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if tabAlignment == .top {
                TabContainer<TabType>(currentTab: $currentTab, tabItems: tabItems, tabAlignment: tabAlignment).padding(.bottom, 0.2)
            }
            Rectangle()
                .overlay(currentTab.content)
            if tabAlignment == .bottom {
                TabContainer<TabType>(currentTab: $currentTab, tabItems: tabItems, tabAlignment: tabAlignment)
            }
        }
    }
}

private struct TabContainer<TabType: TabItem>: View {

    @Binding fileprivate var currentTab: TabType
    fileprivate let tabItems: [TabType]
    fileprivate let tabAlignment: TabAlignment

    fileprivate var body: some View {
        Rectangle()
            .shadow(radius: 0.2, y: self.tabAlignment == .top ? 0.3 : -0.3)
            .frame(height: 50)
            .overlay(TabBar(currentTab: $currentTab, tabItems: tabItems))
    }
}

public enum TabAlignment {
    case top
    case bottom
}

#if DEBUG
struct IndicatorTabView_Previews: PreviewProvider {

    static var previews: some View {

        let viewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        viewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: classic40_preview.lyrics[0].verseContent),
                            VerseViewModel(verseLines: classic40_preview.lyrics[1].verseContent),
                            VerseViewModel(verseNumber: "2", verseLines: classic40_preview.lyrics[2].verseContent),
                            VerseViewModel(verseNumber: "3", verseLines: classic40_preview.lyrics[3].verseContent),
                            VerseViewModel(verseNumber: "4", verseLines: classic40_preview.lyrics[4].verseContent)]
        var selectedTab: HymnLyricsTab = .lyrics(HymnLyricsView(viewModel: viewModel).eraseToAnyView())
        let selectedTabBinding = Binding<HymnLyricsTab>(
            get: {selectedTab},
            set: {selectedTab = $0})
        let tabItems: [HymnLyricsTab] = [
            selectedTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=pdf")).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")).eraseToAnyView())]

        return Group {
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems, tabAlignment: .bottom)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max bottom tabs")
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems)
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
        }
    }
}
#endif
