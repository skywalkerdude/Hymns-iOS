import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class HomeSnapshots: XCTestCase {

    func test_default() {
        let viewModel = HomeViewModel()
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_recentSongs() {
        let viewModel = HomeViewModel()
        viewModel.label = "Recent hymns"
        viewModel.songResults = [cupOfChrist, hymn1151, hymn1334]
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_searchActive() {
        let viewModel = HomeViewModel()
        viewModel.searchActive = true
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_loading() {
        let viewModel = HomeViewModel()
        viewModel.state = .loading
        viewModel.searchActive = true
        viewModel.searchParameter = "She loves me not"
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_searchResults() {
        let viewModel = HomeViewModel()
        viewModel.searchActive = true
        viewModel.searchParameter = "Do you love me?"
        viewModel.songResults = [hymn480, hymn1334, hymn1151]
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }

    func test_noResults() {
        let viewModel = HomeViewModel()
        viewModel.state = .empty
        viewModel.searchActive = true
        viewModel.searchParameter = "She loves me not"
        assertSnapshot(matching: HomeView(viewModel: viewModel), as: .image())
    }
}
