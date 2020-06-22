import PDFKit
import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class DisplayHymnPdfSnapshots: XCTestCase {

    /**
     * PDF Loader that only returns the stored sample pdf.
     */
    class SamplePdfLoader: PDFLoader {

        func load(url: URL) {
            // no-op
        }

        func get(url: URL) -> PDFDocument? {
            sample_pdf
        }
    }

    var preloader: PDFLoader!
    var viewModel: DisplayHymnViewModel!

    override func setUp() {
        super.setUp()
        preloader = SamplePdfLoader()
    }

    func test_classic1151_chords() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier, pdfPreloader: SamplePdfLoader())
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        viewModel.currentTab = .chords(PDFViewer(preloader: preloader,
                                                 url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView())
        viewModel.tabItems = [
            .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: hymn1151_identifier)).maxSize().eraseToAnyView()),
            viewModel.currentTab,
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")!).eraseToAnyView()),
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        sleep(2)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_guitar() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier, pdfPreloader: SamplePdfLoader())
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        viewModel.currentTab = .guitar(PDFViewer(preloader: preloader,
                                                url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())
        viewModel.tabItems = [
            .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).maxSize().eraseToAnyView()),
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView()),
            viewModel.currentTab,
            .piano(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        sleep(2)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }

    func test_classic1151_piano() {
        viewModel = DisplayHymnViewModel(hymnToDisplay: hymn1151_identifier, pdfPreloader: SamplePdfLoader())
        viewModel.isLoaded = true
        viewModel.title = "Hymn 1151"
        viewModel.isFavorited = false
        viewModel.currentTab = .piano(PDFViewer(preloader: preloader,
                                                url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf")!).eraseToAnyView())
        viewModel.tabItems = [
            .lyrics(HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).maxSize().eraseToAnyView()),
            .chords(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=gtpdf")!).eraseToAnyView()),
            .guitar(PDFViewer(url: URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=pdf")!).eraseToAnyView()),
            viewModel.currentTab]
        viewModel.bottomBar = DisplayHymnBottomBarViewModel(hymnToDisplay: hymn1151_identifier)
        sleep(2)
        assertSnapshot(matching: DisplayHymnView(viewModel: viewModel), as: .image())
    }
}
