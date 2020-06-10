import SwiftUI

struct BrowseView: View {

    @State private var currentTab: BrowseTab = .classic

    let tabItems: [BrowseTab] = [.tags, .classic, .newTunes, .newSongs, .children, .scripture, .all]

    var body: some View {
        VStack {
            CustomTitle(title: "Browse")
            IndicatorTabView(currentTab: $currentTab, tabItems: tabItems)
        }
    }
}

#if DEBUG
struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
#endif
