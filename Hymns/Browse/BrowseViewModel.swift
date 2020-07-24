import Combine
import RealmSwift
import Resolver
import SwiftUI

class BrowseViewModel: ObservableObject {

    @Published var currentTab: BrowseTab
    @Published var tabItems: [BrowseTab] = [BrowseTab]()

    init() {
        self.currentTab = .classic(BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .classic)).eraseToAnyView())
        self.tabItems = [.tags(TagListView().eraseToAnyView()),
                         .classic(BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .classic)).eraseToAnyView()),
                         .newTunes(BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .newTune)).eraseToAnyView()),
                         .newSongs(BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .newSong)).eraseToAnyView()),
                         .children(BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .children)).eraseToAnyView()),
                         .scripture(BrowseScripturesView(viewModel: BrowseScripturesViewModel()).eraseToAnyView())]
    }
}

extension Resolver {
    public static func registerBrowseViewModel() {
        register {BrowseViewModel()}.scope(graph)
    }
}
