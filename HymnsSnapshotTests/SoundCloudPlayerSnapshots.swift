import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class SoundCloudPlayerSnapshots: XCTestCase {

    var viewModel: SoundCloudPlayerViewModel!

    override func setUp() {
        super.setUp()
    }

    func test_soundCloudPlayer() {
        let viewModel = SoundCloudPlayerViewModel(dialogModel: .constant(nil))
        viewModel.showPlayer = true
        assertSnapshot(matching: SoundCloudPlayer(viewModel: viewModel), as: .swiftUiImage())
    }
}
