import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BrowseTagsSnapshots: XCTestCase {

    var viewModel: TagListViewModel!

    override func setUp() {
        super.setUp()
    }

    func test_loading() {
        viewModel = TagListViewModel()
        assertSnapshot(matching: TagListView(viewModel: viewModel), as: .image())
    }

    func test_empty() {
        viewModel = TagListViewModel()
        viewModel.tags = [UiTag]()
        assertSnapshot(matching: TagListView(viewModel: viewModel), as: .image())
    }

    func test_tags() {
        viewModel = TagListViewModel()
        viewModel.tags = [UiTag(title: "tag 1", color: .blue),
                          UiTag(title: "tag 2", color: .green),
                          UiTag(title: "tag 3", color: .none)]
        assertSnapshot(matching: TagListView(viewModel: viewModel), as: .image())
    }
}
