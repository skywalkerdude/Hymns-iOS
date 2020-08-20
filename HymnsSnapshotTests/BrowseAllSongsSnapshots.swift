import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BrowseAllSongsSnapshots: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_allSongsView() {
        let viewModel = AllSongsViewModel()
        assertSnapshot(matching: AllSongsView(viewModel: viewModel), as: .swiftUiImage())
    }
}
