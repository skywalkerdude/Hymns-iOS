import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BrowseCategoriesSnapshots: XCTestCase {

    var viewModel: BrowseCategoriesViewModel!

    override func setUp() {
        super.setUp()
    }

    func test_error() {
        viewModel = BrowseCategoriesViewModel(hymnType: .classic)
        viewModel.categories = nil
        assertSnapshot(matching: BrowseCategoriesView(viewModel: viewModel), as: .image())
    }

    func test_loading() {
        viewModel = BrowseCategoriesViewModel(hymnType: .classic)
        assertSnapshot(matching: BrowseCategoriesView(viewModel: viewModel), as: .image())
    }

    func test_categories() {
        viewModel = BrowseCategoriesViewModel(hymnType: nil)
        viewModel.categories
            = [CategoryViewModel(category: "Category 1", subcategories: [SubcategoryViewModel(subcategory: "Subcategory 1", count: 15),
                                                                         SubcategoryViewModel(subcategory: "Subcategory 2", count: 2)]),
               CategoryViewModel(category: "Category 2", subcategories: [SubcategoryViewModel(subcategory: "Subcategory 2", count: 12),
                                                                         SubcategoryViewModel(subcategory: "Subcategory 3", count: 1)])]
        assertSnapshot(matching: BrowseCategoriesView(viewModel: viewModel), as: .image())
    }

    func test_browseView() {
        assertSnapshot(matching: BrowseView(), as: .image())
    }
}
