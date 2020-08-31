#if DEBUG
import Foundation
import PDFKit

/**
 * PDF Loader that only returns the stored sample pdf.
 */
class PdfLoaderTestImpl: PDFLoader {

    func load(url: URL) {
        // no-op
    }

    func get(url: URL) -> PDFDocument? {
        PDFDocument(data: createPdfData())
    }

    func createPdfData() -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "I'm a PDF!"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        return data
    }
}
#endif
