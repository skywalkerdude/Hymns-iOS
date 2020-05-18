import Resolver
import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {

    private let analytics: AnalyticsLogger = Resolver.resolve()
    let url: URL?

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard let url = url else {
            // TODO create error state
            return
        }
        analytics.logDisplayMusicPDF(url: url)
        pdfView.document = PDFDocument(url: url)
        pdfView.sizeToFit()
        pdfView.autoScales = true
    }
}
