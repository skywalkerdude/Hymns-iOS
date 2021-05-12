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

            return Pager(page: .withIndex(viewModel.currentHymn),
                         data: hymns,
                         id: \.id) { index in
                            DisplayHymnView(viewModel: index)
                         }.allowsDragging(viewModel.swipeEnabled).eraseToAnyView()
        }
        .onAppear {
            self.viewModel.populateHymns()
        }
    }
}
