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

            //Change the text from listen on the soundcloud app to SoundCloud Results
            webView.evaluateJavaScript("document.querySelector('.upsellBanner__appButton').innerHTML = 'SoundCloud Search Results';", completionHandler: { (_, _) -> Void in
            })
            //Removes the footer with the Apple store logo
            webView.evaluateJavaScript("document.querySelector('.footer').remove();", completionHandler: { (_, _) -> Void in
            })

            //Removes the category tab like all, songs, playlists, and artists. I am actually not sure if we want to show this or not. I'll leave the code here until we decide.
            webView.evaluateJavaScript("document.querySelector('.categories').remove();", completionHandler: { (_, _) -> Void in
            })

            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}
