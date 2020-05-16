import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {

    let url: URL?
    private let analytics = AnalyticsLogger()

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard let url = url else {
            // TODO create error state
            return
        }
        self.analytics.logDisplayMusicPDF(url: String(describing: url))
        pdfView.document = PDFDocument(url: url)
        pdfView.sizeToFit()
        pdfView.autoScales = true
    }
}
