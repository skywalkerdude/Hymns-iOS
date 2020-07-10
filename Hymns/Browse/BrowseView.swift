import Resolver
import SwiftUI

struct BrowseView: View {

    @ObservedObject private var viewModel: BrowseViewModel

    init(viewModel: BrowseViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            CustomTitle(title: "Browse")
            GeometryReader { geometry in
                IndicatorTabView(geometry: geometry,
                                 currentTab: self.$viewModel.currentTab,
                                 tabItems: self.viewModel.tabItems)
            }
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
