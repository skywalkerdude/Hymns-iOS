import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BrowseScripturesSnapshots: XCTestCase {

    var viewModel: BrowseScripturesViewModel!

    override func setUp() {
        super.setUp()
    }

    func test_error() {
        viewModel = BrowseScripturesViewModel()
        viewModel.scriptures = nil
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .image())
    }

    func test_loading() {
        viewModel = BrowseScripturesViewModel()
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .image())
    }

    func test_scriptures() {
        viewModel = BrowseScripturesViewModel()
        viewModel.scriptures
            = [ScriptureViewModel(book: .genesis,
                                  scriptureSongs: [ScriptureSongViewModel(reference: "1:1", title: "Tree of life", hymnIdentifier: cupOfChrist_identifier),
                                                   ScriptureSongViewModel(reference: "1:26", title: "God created man", hymnIdentifier: hymn1151_identifier)]),
               ScriptureViewModel(book: .revelation,
                                  scriptureSongs: [ScriptureSongViewModel(reference: "13:5", title: "White horse?", hymnIdentifier: hymn40_identifier)])]
        assertSnapshot(matching: BrowseScripturesView(viewModel: viewModel), as: .image())
    }
}
