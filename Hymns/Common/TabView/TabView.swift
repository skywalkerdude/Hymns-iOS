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
                .foregroundColor(Color("darkModePrimary"))
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
            .foregroundColor(Color("darkModePrimary"))
            .overlay(TabBar(currentTab: $currentTab, tabItems: tabItems))
    }
}

public enum TabAlignment {
    case top
    case bottom
}

struct IndicatorTabView_Previews: PreviewProvider {

    static var previews: some View {
        var selectedTab: HomeTab = .home
        let selectedTabBinding = Binding<HomeTab>(
            get: {selectedTab},
            set: {selectedTab = $0})
        let tabItems: [HomeTab] = [
            .home,
            .browse,
            .favorites,
            .settings
        ]

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
