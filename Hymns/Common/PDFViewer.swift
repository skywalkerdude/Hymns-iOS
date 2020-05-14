import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {

    let url: URL?

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard let url = url else {
            // TODO create erroro state
            return
        }
        pdfView.document = PDFDocument(url: url)
        pdfView.sizeToFit()
        pdfView.autoScales = true
    }
}
