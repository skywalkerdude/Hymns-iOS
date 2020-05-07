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
             fatalError()
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
        uiView.load(URLRequest(url: url))
        }
    }
}
