import SwiftUI

/**
 * Custom tab bar that has draws an accented indicator bar below each tab.
 * https://www.objc.io/blog/2020/02/25/swiftui-tab-bar/
 */
struct TabBar<TabItemType: TabItem>: View {

    @Binding var currentTab: TabItemType
    let tabItems: [TabItemType]

    var body: some View {
        HStack {
            ForEach(tabItems) { tabItem in
                Spacer()
                Button(
                    action: {
                        withAnimation(.default) {
                            self.currentTab = tabItem
                        }
                },
                    label: {
                        Group {
                            if self.isSelected(tabItem) {
                                tabItem.selectedLabel
                            } else {
                                tabItem.unselectedLabel
                            }
                        }.accessibility(label: tabItem.a11yLabel).padding()
                })
                    .accentColor(self.isSelected(tabItem) ? .accentColor : .primary)
                    .anchorPreference(
                        key: FirstNonNilPreferenceKey<Anchor<CGRect>>.self,
                        value: .bounds,
                        transform: { anchor in self.isSelected(tabItem) ? .some(anchor) : nil }
                )
                Spacer()
            }
        }.backgroundPreferenceValue(FirstNonNilPreferenceKey<Anchor<CGRect>>.self) { boundsAnchor in
            GeometryReader { proxy in
                boundsAnchor.map { anchor in
                    indicator(
                        width: proxy[anchor].width,
                        offset: .init(
                            width: proxy[anchor].minX,
                            height: proxy[anchor].height
                        )
                    )
                }
            }
        }
    }

    private func isSelected(_ tabItem: TabItemType) -> Bool {
        tabItem == currentTab
    }
}

struct FirstNonNilPreferenceKey<T>: PreferenceKey {
    static var defaultValue: T? { nil }

    static func reduce(value: inout T?, nextValue: () -> T?) {
        value = value ?? nextValue()
    }
}

private func indicator(width: CGFloat, offset: CGSize) -> some View {
    Rectangle()
        .foregroundColor(.accentColor)
        .frame(width: width, height: 3, alignment: .bottom)
        .offset(offset)
}

struct TabBar_Previews: PreviewProvider {

    static var previews: some View {
        var selectedTab: HomeTab = .home
        return Group {
            TabBar(
                currentTab: Binding<HomeTab>(
                    get: {selectedTab},
                    set: {selectedTab = $0}),
                tabItems: [
                    .home,
                    .browse,
                    .favorites,
                    .settings
            ])
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
