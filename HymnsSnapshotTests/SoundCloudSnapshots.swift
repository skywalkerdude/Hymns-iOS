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
        var published = Published<String?>(initialValue: nil)
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil), title: published.projectedValue)
        viewModel.showPlayer = true
        assertVersionedSnapshot(matching: SoundCloudPlayer(viewModel: viewModel), as: .image(layout: .fixed(width: 400, height: 200)))
    }

    func test_soundCloudPlayer_a11ySize() {
        var published = Published<String?>(initialValue: nil)
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil), title: published.projectedValue)
        viewModel.showPlayer = true
        let player = SoundCloudPlayer(viewModel: viewModel).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        assertVersionedSnapshot(matching: player, as: .image(layout: .fixed(width: 600, height: 200)))
    }

    func test_defaultState() {
        let viewModel = SoundCloudViewModel(url: URL(string: "http://www.example.com")!)
        assertVersionedSnapshot(matching: SoundCloudView(dialogModel: .constant(nil), soundCloudPlayer: .constant(nil), viewModel: viewModel),
                                as: .swiftUiImage(precision: 0.99), timeout: 30)
    }

    // TODO not working right... for some reason the caret shows up fine in the preview in SoundCloudPlayer but doesn't work in the snapshot tests...
    func test_minimizeCaret() {
        let viewModel = SoundCloudViewModel(url: URL(string: "https://www.example.com")!)
        viewModel.showMinimizeCaret = true
        assertVersionedSnapshot(matching: SoundCloudView(dialogModel: .constant(nil), soundCloudPlayer: .constant(nil), viewModel: viewModel),
                                as: .swiftUiImage(precision: 0.99), timeout: 30)
    }

    // TODO not working right... for some reason the caret/tooltip show up fine in the preview in SoundCloudPlayer but doesn't work in the snapshot tests...
    func test_minimizeCaretAndToolTip() {
        let viewModel = SoundCloudViewModel(url: URL(string: "https://www.example.com")!)
        viewModel.showMinimizeCaret = true
        viewModel.showMinimizeToolTip = true
        assertVersionedSnapshot(matching: SoundCloudView(dialogModel: .constant(nil), soundCloudPlayer: .constant(nil), viewModel: viewModel),
                                as: .swiftUiImage(precision: 0.99), timeout: 30)
    }
}
