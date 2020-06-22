import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class DisplayHymnSnapshots: XCTestCase {

    var viewModel: DisplayHymnViewModel!

    override func setUp() {
        super.setUp()
    }

    func test_loading() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn40_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1334() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1334_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1334"
        viewModel.isFavorited = true
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1334_identifier)
        lyricsViewModel.lyrics
            = [VerseViewModel(verseNumber: "1", verseLines: hymn1334_hymn.lyrics[0].verseContent)
        ]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [
            viewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=gtpdf")!).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=pdf")!).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1334/f=ppdf")!).eraseToAnyView())]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1334_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_noTabs() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)
        lyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: hymn1151_hymn.lyrics[0].verseContent),
                                  VerseViewModel(verseLines: hymn1151_hymn.lyrics[1].verseContent),
                                  VerseViewModel(verseNumber: "2", verseLines: hymn1151_hymn.lyrics[2].verseContent),
                                  VerseViewModel(verseNumber: "3", verseLines: hymn1151_hymn.lyrics[3].verseContent),
                                  VerseViewModel(verseNumber: "4", verseLines: hymn1151_hymn.lyrics[4].verseContent)]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [HymnLyricsTab]()
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_oneTab() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)
        lyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: hymn1151_hymn.lyrics[0].verseContent),
                                  VerseViewModel(verseLines: hymn1151_hymn.lyrics[1].verseContent),
                                  VerseViewModel(verseNumber: "2", verseLines: hymn1151_hymn.lyrics[2].verseContent),
                                  VerseViewModel(verseNumber: "3", verseLines: hymn1151_hymn.lyrics[3].verseContent),
                                  VerseViewModel(verseNumber: "4", verseLines: hymn1151_hymn.lyrics[4].verseContent)]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [viewModel.currentTab]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_twoTabs() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)
        lyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: hymn1151_hymn.lyrics[0].verseContent),
                                  VerseViewModel(verseLines: hymn1151_hymn.lyrics[1].verseContent),
                                  VerseViewModel(verseNumber: "2", verseLines: hymn1151_hymn.lyrics[2].verseContent),
                                  VerseViewModel(verseNumber: "3", verseLines: hymn1151_hymn.lyrics[3].verseContent),
                                  VerseViewModel(verseNumber: "4", verseLines: hymn1151_hymn.lyrics[4].verseContent)]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [
            viewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView())]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_threeTabs() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)
        lyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: hymn1151_hymn.lyrics[0].verseContent),
                                  VerseViewModel(verseLines: hymn1151_hymn.lyrics[1].verseContent),
                                  VerseViewModel(verseNumber: "2", verseLines: hymn1151_hymn.lyrics[2].verseContent),
                                  VerseViewModel(verseNumber: "3", verseLines: hymn1151_hymn.lyrics[3].verseContent),
                                  VerseViewModel(verseNumber: "4", verseLines: hymn1151_hymn.lyrics[4].verseContent)]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [
            viewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_fourTabs() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier)
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        let lyricsViewModel = HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)
        lyricsViewModel.lyrics = [VerseViewModel(verseNumber: "1", verseLines: hymn1151_hymn.lyrics[0].verseContent),
                                  VerseViewModel(verseLines: hymn1151_hymn.lyrics[1].verseContent),
                                  VerseViewModel(verseNumber: "2", verseLines: hymn1151_hymn.lyrics[2].verseContent),
                                  VerseViewModel(verseNumber: "3", verseLines: hymn1151_hymn.lyrics[3].verseContent),
                                  VerseViewModel(verseNumber: "4", verseLines: hymn1151_hymn.lyrics[4].verseContent)]
        viewModel.currentTab = .lyrics(HymnLyricsView(viewModel: lyricsViewModel).maxSize().eraseToAnyView())
        viewModel.tabItems = [
            viewModel.currentTab,
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")!).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())]
        let bottomBarViewModel = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        bottomBarViewModel.songInfo = SongInfoDialogViewModel(hymnToDisplay: hymn1151_identifier)
        bottomBarViewModel.shareableLyrics = "Shareable lyrics"
        bottomBarViewModel.languages = [cupOfChrist_songResult]
        bottomBarViewModel.relevant = [hymn480_songResult]
        bottomBarViewModel.audioPlayer = AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)
        let songInfoDialogViewModel = SongInfoDialogViewModel(hymnToDisplay: hymn1151_identifier)
        songInfoDialogViewModel.songInfo = [SongInfoViewModel(label: "label", values: ["value1", "value2"])]
        bottomBarViewModel.songInfo = songInfoDialogViewModel
        viewModel.bottomBar = bottomBarViewModel
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }
}
