import SwiftUIPager
import SwiftUI

struct DisplayHymnContainerView: View {

    @ObservedObject private var viewModel: DisplayHymnContainerViewModel

    init(viewModel: DisplayHymnContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group { () -> AnyView in
            guard let hymns = self.viewModel.hymns else {
                return ActivityIndicator().maxSize().eraseToAnyView()
            }
            if hymns.count == 1, let onlyHymn = hymns.first {
                return DisplayHymnView(viewModel: onlyHymn).eraseToAnyView()
            }
            return Pager(page: Page.withIndex(viewModel.currentHymn),
                         data: Array(0..<hymns.count),
                         id: \.self,
                         content: { index in
                            DisplayHymnView(viewModel: hymns[index])
                         }).allowsDragging(viewModel.swipeEnabled).eraseToAnyView()
        }.onAppear {
            self.viewModel.populateHymns()
        }
    }
}
