import Foundation
import SwiftUI

/**
 * Custom `TabView` that uses a custom `TabBar` which draws an accented indicator below each tab.
 * Idea for this `TabView` class taken from: https://github.com/innoreq/IRScrollableTabView
 */
public struct IndicatorTabView<TabType: TabItem>: View {

    @Binding var currentTab: TabType
    let tabItems: [TabType]

    public var body: some View {
        return
            VStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.white)
                    .overlay(currentTab.content)

                Rectangle()
                    .shadow(radius: 3)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .overlay(TabBar(currentTab: $currentTab, tabItems: tabItems))
        }
    }
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
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            IndicatorTabView(currentTab: selectedTabBinding, tabItems: tabItems)
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
        }
    }
}
