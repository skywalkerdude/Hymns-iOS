import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */
struct WebView: UIViewRepresentable {
 //    @State var cache = [URL: WKWebView]()

    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        guard let url = url else {
            // TODO show error state
            return WKWebView() //empty webview
        }

        if let webView = WebViewPreloader.webviews[url] {
            return webView
        }

        let webView = WKWebView()
        WebViewPreloader.webviews[url] = webView
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
