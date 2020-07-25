import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class AudioPlayerSnapshots: XCTestCase {

    var viewModel: AudioPlayerViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AudioPlayerViewModel(url: URL(string: "url")!)
    }

    func test_currentlyPlaying() {
        viewModel.playbackState = .playing
        viewModel.songDuration = 100
        viewModel.currentTime = 50
        assertSnapshot(matching: AudioPlayer(viewModel: viewModel), as: .image())
    }

    func test_stopped() {
        viewModel.playbackState = .stopped
        viewModel.songDuration = 500
        viewModel.shouldRepeat = true
        assertSnapshot(matching: AudioPlayer(viewModel: viewModel), as: .image())
    }

    func test_buffering() {
        viewModel.playbackState = .buffering
        viewModel.songDuration = 20
        assertSnapshot(matching: AudioPlayer(viewModel: viewModel), as: .image())
    }
}
