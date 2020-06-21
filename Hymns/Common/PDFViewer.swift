import Resolver
import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {

    private let analytics: AnalyticsLogger
    private let preloader: PDFLoader
    private let url: URL

    init(analytics: AnalyticsLogger = Resolver.resolve(), preloader: PDFLoader = Resolver.resolve(), url: URL) {
        self.analytics = analytics
        self.preloader = preloader
        self.url = url
    }

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        analytics.logDisplayMusicPDF(url: url)
        if let preloadedDoc = preloader.get(url: url) {
            pdfView.document = preloadedDoc
        } else {
            pdfView.document = PDFDocument(url: url)
        }

        // Display error state
        if pdfView.document == nil {
            displayErrorState(pdfView)
        }

        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.sizeToFit()
        pdfView.autoScales = true
    }

    private func displayErrorState(_ pdfView: PDFView) {
        if let fileURL = Bundle.main.url(forResource: "pdfErrorState", withExtension: "pdf") {
            pdfView.document = PDFDocument(url: fileURL)
        }
    }
}
