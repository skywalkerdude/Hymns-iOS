import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class HomeSnapshots: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }

    func test_default() {
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_recentSongs() {
        viewModel.state = .results
        viewModel.label = "Recent hymns"
        viewModel.songResults = [cupOfChrist, hymn1151, hymn1334]
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_noRecentSongs() {
        viewModel.state = .results
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_searchActive() {
        viewModel.state = .results
        viewModel.searchActive = true
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_loading() {
        viewModel.state = .loading
        viewModel.searchActive = true
        viewModel.searchParameter = "She loves me not"
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_searchResults() {
        viewModel.state = .results
        viewModel.searchActive = true
        viewModel.searchParameter = "Do you love me?"
        viewModel.songResults = [hymn480, hymn1334, hymn1151]
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_noResults() {
        viewModel.state = .empty
        viewModel.searchActive = true
        viewModel.searchParameter = "She loves me not"
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }
}
