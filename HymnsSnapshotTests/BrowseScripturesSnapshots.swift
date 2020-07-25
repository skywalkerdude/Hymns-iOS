import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BrowseScripturesSnapshots: XCTestCase {

    var viewModel: BrowseScripturesViewModel!

    override func setUp() {
        super.setUp()
        viewModel = BrowseScripturesViewModel()
    }

    func test_error() {
        viewModel.scriptures = nil
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_loading() {
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_scriptures() {
        viewModel.scriptures
            = [ScriptureViewModel(book: .genesis,
                                  scriptureSongs: [ScriptureSongViewModel(reference: "1:1", title: "Tree of life", hymnIdentifier: cupOfChrist_identifier),
                                                   ScriptureSongViewModel(reference: "1:26", title: "God created man", hymnIdentifier: hymn1151_identifier)]),
               ScriptureViewModel(book: .revelation,
                                  scriptureSongs: [ScriptureSongViewModel(reference: "13:5", title: "White horse?", hymnIdentifier: hymn40_identifier)])]
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_scripture_song() {
        let viewModel = ScriptureSongViewModel(reference: "1:19", title: "And we have the prophetic word",
                                               hymnIdentifier: PreviewHymnIdentifiers.cupOfChrist)
        assertSnapshot(matching: ScriptureSongView(viewModel: viewModel).environment(\.sizeCategory, .medium), as: .swiftUiImage())
        assertSnapshot(matching: ScriptureSongView(viewModel: viewModel).environment(\.sizeCategory, .extraExtraExtraLarge), as: .swiftUiImage())
        assertSnapshot(matching: ScriptureSongView(viewModel: viewModel).environment(\.sizeCategory, .accessibilityMedium), as: .swiftUiImage())
        assertSnapshot(matching: ScriptureSongView(viewModel: viewModel).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge), as: .swiftUiImage())
    }
}
