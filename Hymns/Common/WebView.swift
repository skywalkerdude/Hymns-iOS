import SwiftUI
import WebKit

/**
 * Generic container to display a URL wiithin the app.
 */

struct WebView: UIViewRepresentable {
    
    static var cache = [URL: WKWebView]()
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = request.url else { fatalError() }
        
        if let webView = WebView.cache[url] {
            return webView
        }
        
        let webView = WKWebView()
        WebView.cache[url] = webView
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(request)
        }
    }
}

