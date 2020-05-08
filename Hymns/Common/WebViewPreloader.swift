import SwiftUI
import WebKit

/// Keeps a cache of webviews and starts loading them the first time they are queried
class WebViewPreloader {
    static var webviews = [URL: WKWebView]()

    /// Registers a web view for preloading. If an webview for that URL already
    /// exists, the web view reloads the request
    ///https://stackoverflow.com/questions/48839180/preload-multiple-local-webviews

     func preload(url: URL) {
        preloadWebview(for: url).load(URLRequest(url: url))
    }

    /// Creates or returns an already cached webview for the given URL.
    /// If the webview doesn't exist, it gets created and asked to load the URL
    ///
    /// - Parameter url: the URL to prefecth
    /// - Returns: a new or existing web view
    ///
    ///Screen sizing because we are preloading in the viewModel so it needs a size to load up with. The view will resize it when called.

     func preloadWebview(for url: URL) -> WKWebView {
        if let cachedWebView = WebViewPreloader.webviews[url] { return cachedWebView }
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        webview.load(URLRequest(url: url))
        WebViewPreloader.webviews[url] = webview
        return webview
    }
}
