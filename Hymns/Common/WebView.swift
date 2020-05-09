import Resolver
import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */
struct WebView: UIViewRepresentable {

    private let preloader: WebViewPreloader
    private let url: URL?

    init(url: URL?, preloader: WebViewPreloader = Resolver.resolve()) {
        self.preloader = preloader
        self.url = url
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let url = url else {
            // TODO show error state
            return WKWebView() //empty webview
        }

        if let webView = preloader.getCachedWebview(url) {
            return webView
        }

        let webView = WKWebView()
        preloader.cacheWebview(url: url, webView: webView)
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
}
