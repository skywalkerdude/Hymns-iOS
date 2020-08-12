import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class SoundCloudSnapshots: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_soundCloudPlayer() {
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil))
        viewModel.showPlayer = true
        assertSnapshot(matching: SoundCloudPlayer(viewModel: viewModel), as: .image(layout: .fixed(width: 400, height: 200)))
    }

    func test_soundCloudPlayer_a11ySize() {
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil))
        viewModel.showPlayer = true
        let player = SoundCloudPlayer(viewModel: viewModel).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        assertSnapshot(matching: player, as: .image(layout: .fixed(width: 600, height: 200)))
    }

    func test_searchPath_withNoToolTipOrCaret() {
        let viewModel = SoundCloudViewModel(url: URL(string: "http://www.example.com/search/path")!)
        assertSnapshot(matching: SoundCloudView(dialogModel: .constant(nil),
                                                soundCloudPlayer: .constant(nil),
                                                viewModel: viewModel),
                       as: .swiftUiImage(precision: 0.99))
    }

    func test_nonSearchPath_withToolTipAndCaret() {
        let viewModel = SoundCloudViewModel(url: URL(string: "http://www.example.com")!)
        assertSnapshot(matching: SoundCloudView(dialogModel: .constant(nil),
                                                soundCloudPlayer: .constant(nil),
                                                viewModel: viewModel),
                       as: .swiftUiImage(precision: 0.99))
    }
}
