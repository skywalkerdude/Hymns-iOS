import SwiftUI

struct DisplayHymnContainerView: View {

    @ObservedObject private var viewModel: DisplayHymnContainerViewModel

    init(viewModel: DisplayHymnContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        PagerView(currentPage: $viewModel.currentIndex, viewModel.hymns)
    }
}

struct DisplayHymnContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let newTune285ViewModel = DisplayHymnContainerViewModel(hymnToDisplay: PreviewHymnIdentifiers.newTune285)
        let newTune285 = DisplayHymnContainerView(viewModel: newTune285ViewModel)
        return Group {
            newTune285
        }
    }
}
