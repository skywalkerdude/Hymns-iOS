import SwiftUI
import WebKit

struct CommentWebView: UIViewRepresentable {
    @Binding var isLoading: Bool  //Used for activity indicator
    var url: URL
    var loadStatusChanged: ((Bool, Error?) -> Void)?

    func makeCoordinator() -> CommentWebView.Coordinator {
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
        let parent: CommentWebView

        init(_ parent: CommentWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.querySelector('.header').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.row').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.body.hymn').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.hymn-content').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.sidebar').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.hymn-nums').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.nav').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.row.text-center').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.footer').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.btn-group').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.getElementById('song-title').remove();", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.top-right-button').remove();", completionHandler: { (_, _) -> Void in
                self.parent.isLoading = false  //Used for activity indicator
                self.parent.loadStatusChanged?(false, nil)
            })
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}
