import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */
struct WebView: UIViewRepresentable {

    static var cache = [URL: WKWebView]()

    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        guard let url = url else {
            // TODO show error state
            return WKWebView() //empty webview
        }

        if let webView = WebView.cache[url] {
            return webView
        }

        let webView = WKWebView()
        WebView.cache[url] = webView
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = url else {
            // TODO show error state
            return
        }

        if uiView.url == nil {
        print("Having to load afresh")
        uiView.load(URLRequest(url: url))
        }
    }


    /// Registers a web view for preloading. If an webview for that URL already
    /// exists, the web view reloads the request
    ///https://stackoverflow.com/questions/48839180/preload-multiple-local-webviews

    static func preload(url: URL) {
        preloadWebview(for: url).load(URLRequest(url: url))
    }

    /// Creates or returns an already cached webview for the given URL.
    /// If the webview doesn't exist, it gets created and asked to load the URL
    ///
    /// - Parameter url: the URL to prefecth
    /// - Returns: a new or existing web view
    ///
    ///Screen sizing because we are preloading in the viewModel so it needs a size to load up with. The view will resize it when called.

    static func preloadWebview(for url: URL) -> WKWebView {
        if let cachedWebView = WebView.cache[url] { return cachedWebView }
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        webview.load(URLRequest(url: url))
        WebView.cache[url] = webview
        return webview
    }
}
