import Combine
import Foundation
import PDFKit
import Resolver

/**
 * Asynchronously loads and caches PDF documents loaded from web URLs
 */
class PDFLoader {

    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let session: URLSession

    private var cache = [URL: PDFDocument]()
    private var disposables = Set<AnyCancellable>()

    init(analytics: AnalyticsLogger = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         session: URLSession = Resolver.resolve()) {
        self.backgroundQueue = backgroundQueue
        self.analytics = analytics
        self.session = session
    }

    /**
     * Saves the `HTML` or `URL` for the current session.
     */
    func load(url: URL) {
        backgroundQueue.async {
            self.cache[url] = PDFDocument(url: url)
        }
    }

    func get(url: URL) -> PDFDocument? {
        return cache[url]
    }
}
