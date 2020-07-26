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
            set: {self.dialogBuilder = $0}), viewModel: viewModel).padding()
        assertSnapshot(matching: bottomBar, as: .image())
    }

    func test_maximumButtons() {
        viewModel.buttons = [
            .soundCloud(URL(string: "https://soundcloud.com/search?q=query")!),
            .youTube(URL(string: "https://www.youtube.com/results?search_query=search")!),
            .languages([SongResultViewModel(title: "language", destinationView: EmptyView().eraseToAnyView())]),
            .musicPlayback(AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)),
            .relevant([SongResultViewModel(title: "relevant", destinationView: EmptyView().eraseToAnyView())]),
            .tags,
            .songInfo(SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
        ]

        let bottomBar = DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {self.dialogBuilder},
            set: {self.dialogBuilder = $0}), viewModel: viewModel).padding()
        assertSnapshot(matching: bottomBar, as: .image())
    }

    func test_overflowMenu() {
        viewModel.buttons = [
            .share("lyrics"),
            .fontSize,
            .languages([SongResultViewModel(title: "language", destinationView: EmptyView().eraseToAnyView())]),
            .musicPlayback(AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)),
            .relevant([SongResultViewModel(title: "relevant", destinationView: EmptyView().eraseToAnyView())]),
            .tags
        ]
        viewModel.overflowButtons = [
            .soundCloud(URL(string: "https://soundcloud.com/search?q=query")!),
            .youTube(URL(string: "https://www.youtube.com/results?search_query=search")!),
            .songInfo(SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
        ]

        let bottomBar = DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {self.dialogBuilder},
            set: {self.dialogBuilder = $0}), viewModel: viewModel).padding()
        assertSnapshot(matching: bottomBar, as: .image())
    }
}
