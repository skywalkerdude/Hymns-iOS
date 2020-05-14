import Resolver
import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */
struct WebView: UIViewRepresentable {

    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = url else {
            // TODO create error state
            return
        }
        uiView.load(URLRequest(url: url))
    }
}
