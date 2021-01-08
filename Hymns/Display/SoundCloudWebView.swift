import SwiftUI
import WebKit

struct SoundCloudWebView: UIViewRepresentable {

    @ObservedObject var viewModel: SoundCloudViewModel

    func makeUIView(context: Context) -> WKWebView {
        // Enable javascript in WKWebView to interact with the web app
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = true

        viewModel.titleObservation = webView.observe(\WKWebView.title, options: .new, changeHandler: viewModel.titleObserver)

        webView.load(URLRequest(url: viewModel.url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
