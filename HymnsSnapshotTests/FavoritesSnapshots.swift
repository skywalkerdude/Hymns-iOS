import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class FavoritesSnapshots: XCTestCase {

    var viewModel: FavoritesViewModel!

    override func setUp() {
        super.setUp()
        viewModel = FavoritesViewModel()
    }

    func test_loading() {
        assertSnapshot(matching: FavoritesView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_noFavorites() {
        viewModel.favorites = [SongResultViewModel]()
        assertSnapshot(matching: FavoritesView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_searchActive() {
        viewModel.favorites = [cupOfChrist_songResult, hymn1151_songResult, joyUnspeakable_songResult, sinfulPast_songResult]
        assertSnapshot(matching: FavoritesView(viewModel: viewModel), as: .swiftUiImage())
    }
}
