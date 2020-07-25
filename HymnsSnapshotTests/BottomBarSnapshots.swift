import Foundation
import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class BottomBarSnapshots: XCTestCase {

    var dialogBuilder: (() -> AnyView)?
    var viewModel: DisplayHymnBottomBarViewModel!

    override func setUp() {
        super.setUp()
        viewModel = DisplayHymnBottomBarViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
    }

    func test_minimumButtons() {
        let bottomBar = DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {self.dialogBuilder},
            set: {self.dialogBuilder = $0}), viewModel: viewModel)
        assertSnapshot(matching: bottomBar, as: .image())
    }

    func test_maximumButtons() {
        viewModel.songInfo.songInfo = [SongInfoViewModel(label: "label", values: ["values"])]
        viewModel.languages = [SongResultViewModel(title: "language", destinationView: EmptyView().eraseToAnyView())]
        viewModel.relevant = [SongResultViewModel(title: "relevant", destinationView: EmptyView().eraseToAnyView())]
        viewModel.audioPlayer = AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)

        let bottomBar = DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {self.dialogBuilder},
            set: {self.dialogBuilder = $0}), viewModel: viewModel)
        assertSnapshot(matching: bottomBar, as: .image())
    }
}
