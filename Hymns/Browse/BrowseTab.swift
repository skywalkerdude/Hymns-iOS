import Foundation
import SwiftUI

enum BrowseTab {
    case classic
    case newTunes
    case newSongs
    case children
    case all
}

extension BrowseTab {

    var label: String {
        switch self {
        case .classic:
            return "Classic Hymns"
        case .newTunes:
            return "New Tunes"
        case .newSongs:
            return "New Songs"
        case .children:
            return "Children's Songs"
        case .all:
            return "All Songs"
        }
    }
}

extension BrowseTab: TabItem {

    var id: String { self.label }

    var content: AnyView {
        switch self {
        case .classic:
            return BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .classic)).eraseToAnyView()
        case .newTunes:
            return BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .newTune)).eraseToAnyView()
        case .newSongs:
            return BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .newSong)).eraseToAnyView()
        case .children:
            return BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: .children)).eraseToAnyView()
        case .all:
            return BrowseCategoriesView(viewModel: BrowseCategoriesViewModel(hymnType: nil)).eraseToAnyView()
        }
    }

    var selectedLabel: some View {
        Text(label).font(.body).foregroundColor(.accentColor)
    }

    var unselectedLabel: some View {
        Text(label).font(.body).foregroundColor(.primary)
    }

    var a11yLabel: Text {
        Text(label)
    }

    static func == (lhs: BrowseTab, rhs: BrowseTab) -> Bool {
        lhs.label == rhs.label
    }
}

#if DEBUG
struct BrowseTab_Previews: PreviewProvider {
    static var previews: some View {
        var classicTab: BrowseTab = .classic
        let newTunesTab: BrowseTab = .newTunes
        let newSongsTab: BrowseTab = .newSongs
        let childrensTab: BrowseTab = .children
        var allTab: BrowseTab = .all

        let currentTabClassic = Binding<BrowseTab>(
            get: {classicTab},
            set: {classicTab = $0})
        let clasicSelected = TabBar(currentTab: currentTabClassic, tabItems: [classicTab, newTunesTab, newSongsTab, childrensTab, allTab])

        let currentTabAll = Binding<BrowseTab>(
            get: {allTab},
            set: {allTab = $0})
        let allSelected = TabBar(currentTab: currentTabAll, tabItems: [classicTab, newTunesTab, newSongsTab, childrensTab, allTab])

        return Group {
            clasicSelected.previewDisplayName("Classic selected")
            allSelected.previewDisplayName("All selected")
        }.toPreviews()
    }
}
#endif
