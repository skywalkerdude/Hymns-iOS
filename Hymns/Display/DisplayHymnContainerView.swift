import SwiftUI

struct DisplayHymnContainerView: View {

    @ObservedObject private var viewModel: DisplayHymnContainerViewModel

    init(viewModel: DisplayHymnContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        PagerView(pageCount: viewModel.hymns.count, currentIndex: $viewModel.currentIndex) {
            ForEach(viewModel.hymns) { hymn in
                if hymn.isLoaded {
                    DisplayHymnView(viewModel: hymn)
                } else {
                    // TODO replace with View Extension in https://github.com/HymnalDreamTeam/Hymns-iOS/pull/99
                    ActivityIndicator().frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
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
