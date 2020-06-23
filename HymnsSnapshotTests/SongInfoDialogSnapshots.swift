import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class SongInfoDialogSnapshots: XCTestCase {

    var viewModel: SongInfoDialogViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SongInfoDialogViewModel(hymnToDisplay: hymn40_identifier)
    }

    func test_empty() {
        assertSnapshot(matching: SongInfoDialog(viewModel: viewModel), as: .image())
    }

    func test_songInfo() {
        viewModel.songInfo = [SongInfoViewModel(label: "Category", values: ["Worship of the Father"]),
                              SongInfoViewModel(label: "Subcategory", values: ["As the Source of Life"]),
                              SongInfoViewModel(label: "Author", values: ["Will Jeng", "Titus Ting"])]
        assertSnapshot(matching: SongInfoDialog(viewModel: viewModel), as: .image())
    }

    func test_longValues() {
        viewModel.songInfo = [SongInfoViewModel(label: "Category", values: ["Worship Worship Worship of of of the the the Father Father Father"]),
                              SongInfoViewModel(label: "Subcategory", values: ["As As As the the the Source Source Source of of of Life Life Life"]),
                              SongInfoViewModel(label: "Author", values: ["Will Will Will Jeng Jeng Jeng", "Titus Titus Titus Ting Ting Ting"])]
        assertSnapshot(matching: SongInfoDialog(viewModel: viewModel), as: .image())
    }
}
