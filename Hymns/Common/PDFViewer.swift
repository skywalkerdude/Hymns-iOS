import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {

    let url: URL?

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(url: url!)
        pdfView.autoScales = true
    }
}
