import Foundation
import PDFKit
@testable import Hymns

class PDFs{}

let sample_pdf = getPdf(fileName: "sample")

func getPdf(fileName: String) -> PDFDocument {
    let path = Bundle(for: Hymns.self).path(forResource: fileName, ofType: "pdf")!
    return PDFDocument(url: URL(fileURLWithPath: path))!
}
