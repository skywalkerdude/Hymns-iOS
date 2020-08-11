import SwiftUI
import WebKit

struct SoundCloudWebView: UIViewRepresentable {
    var url: URL

    func makeCoordinator() -> SoundCloudWebView.Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    class Coordinator: NSObject, WKNavigationDelegate {

        override init() {}

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Remove the header banner so we don't have two SoundCloud logos on top of each other
            webView.evaluateJavaScript("$('.app__header').remove()",
                                       completionHandler: { (_, _) -> Void in })
            // Remove the upsell banner (which doesn't really work)
            webView.evaluateJavaScript("$('.app__upsell').remove()",
                                       completionHandler: { (_, _) -> Void in })
            // Make the top padding 0px because we are removing the upsell and the header
            webView.evaluateJavaScript("document.getElementById('content').style.paddingTop = '0px'",
                                       completionHandler: { (_, _) -> Void in })
        }
    }
}
