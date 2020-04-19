import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */
struct WebView: UIViewRepresentable {

    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
