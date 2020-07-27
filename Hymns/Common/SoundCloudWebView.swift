import SwiftUI
import WebKit

struct SoundCloudWebView: UIViewRepresentable {
    @Binding var isLoading: Bool  //Used for activity indicator
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

            parent.isLoading = false  //Used for activity indicator
            webView.evaluateJavaScript("document.querySelector('.upsellBanner__appButton').innerHTML = 'SoundCloud Results';", completionHandler: { (_, _) -> Void in
            })
            webView.evaluateJavaScript("document.querySelector('.app__footerPanel').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.footer.show').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.footer').remove();", completionHandler: { (_, _) -> Void in
            })

            webView.evaluateJavaScript("document.querySelector('.categories').remove();", completionHandler: { (_, _) -> Void in
            })

            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}
