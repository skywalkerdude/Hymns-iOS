import Resolver
import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    private let preloader: PDFLoader = Resolver.resolve()
    private let analytics: AnalyticsLogger = Resolver.resolve()
    let url: URL?

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard let url = url else {
            displayErrorState(pdfView)
            return
        }
        analytics.logDisplayMusicPDF(url: url)
        if let preloadedDoc = preloader.get(url: url) {
            pdfView.document = preloadedDoc
        } else {
            pdfView.document = PDFDocument(url: url)
        }

        //Display error state
        if pdfView.document == nil {
            displayErrorState(pdfView)
        }
        pdfView.sizeToFit()
        pdfView.autoScales = true
    }

    private func displayErrorState(_ pdfView: PDFView) {
        if let fileURL = Bundle.main.url(forResource: "pdfErrorState", withExtension: "pdf") {
            pdfView.document = PDFDocument(url: fileURL)
        }
    }
}
