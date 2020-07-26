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

    private let mainQueue: DispatchQueue
    private let session: URLSession
    private var cache = [URL: PDFDocument]()

    init(mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         session: URLSession = Resolver.resolve()) {
        self.mainQueue = mainQueue
        self.session = session
    }

    /**
     * Saves the `HTML` or `URL` for the current session.
     */
    func load(url: URL) {
        mainQueue.async {
            if let document = PDFDocument(url: url) {
                self.cache[url] = document
            }
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
