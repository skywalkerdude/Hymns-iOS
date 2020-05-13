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
        }
    }

//By creating a whole different type we are able to circumvent using updateUIView. If in a SwiftUI view the state changes the UIKit wrapper will call updateUIView. However, with WebView that is problematic because we are stuck with no choice but to update that WebView using something like load which is slow and flashy compared to our ability to just return a WebView directly that was already cached when makeUIView is called.
struct WebView2: UIViewRepresentable {

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
        }
    }

//By creating a whole different type we are able to circumvent using updateUIView. If in a SwiftUI view the state changes the UIKit wrapper will call updateUIView. However, with WebView that is problematic because we are stuck with no choice but to update that WebView using something like load which is slow and flashy compared to our ability to just return a WebView directly that was already cached when makeUIView is called.
struct WebView3: UIViewRepresentable {

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
        }
    }
