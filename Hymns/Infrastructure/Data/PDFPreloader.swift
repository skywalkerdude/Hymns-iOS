import Combine
import Foundation
import PDFKit
import Resolver

/**
 * Asynchronously loads and caches PDF documents loaded from web URLs
 */
protocol PDFLoader {
    func load(url: URL)

    func get(url: URL) -> PDFDocument?
}

class PDFLoaderImpl: PDFLoader {

    private let session: URLSession
    private var cache = [URL: PDFDocument]()

    init(session: URLSession = Resolver.resolve()) {
        self.session = session
    }

    /**
     * Saves the `HTML` or `URL` for the current session.
     */
    func load(url: URL) {
        if let document = PDFDocument(url: url) {
            self.cache[url] = document
        }
    }

    func get(url: URL) -> PDFDocument? {
        return cache[url]
    }
}

extension Resolver {
    public static func registerPDFLoader() {
        register { PDFLoaderImpl() as PDFLoader }.scope(application)
    }
}
