import SwiftUI
import WebKit

struct SoundCloudWebView: UIViewRepresentable {
    var url: URL
    var loadStatusChanged: ((Bool, Error?) -> Void)?

    func makeCoordinator() -> SoundCloudWebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: SoundCloudWebView

        init(_ parent: SoundCloudWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Remove the header banner if we aren't on the search page so we don't have two SoundCloud logos on top of each other
            webView.evaluateJavaScript("if (window.location.pathname != '/search') { $('.app__header').remove() }",
                                       completionHandler: { (_, _) -> Void in })
            // Remove the upsell banner (which doesn't really work)
            webView.evaluateJavaScript("$('.app__upsell').remove()",
                                       completionHandler: { (_, _) -> Void in })
            // If we are on the search screen, make the top padding 45px to make up for the upsell banner disappearing.
            // If we are not on the search screen, then make the top padding 0px because we are also removing the header
            webView.evaluateJavaScript("document.getElementById('content').style.paddingTop = window.location.pathname == '/search' ? '45px' : '0px'",
                                       completionHandler: { (_, _) -> Void in })
            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}
