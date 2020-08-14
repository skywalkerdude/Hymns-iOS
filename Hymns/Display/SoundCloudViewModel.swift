import Combine
import Resolver
import WebKit

class SoundCloudViewModel: ObservableObject {

    @UserDefault("has_seen_soundcloud_minimize_tooltip", defaultValue: false) var hasSeenSoundCloudMinimizeTooltip: Bool

    @Published var url: URL
    @Published var showMinimizeCaret: Bool = false
    @Published var showMinimizeToolTip: Bool = false

    var urlObserveration: NSKeyValueObservation?

    var urlObserver: ((WKWebView, NSKeyValueObservedChange<URL?>) -> Void) { { (webView, change) in
        guard let urlOptional = change.newValue, let url = urlOptional else {
            return
        }

        if UIDevice.current.userInterfaceIdiom != .pad {
            let path = url.path
            if path.starts(with: "/search") {
                self.showMinimizeCaret = false
            } else {
                self.showMinimizeCaret = true
                if !self.hasSeenSoundCloudMinimizeTooltip {
                    self.showMinimizeToolTip = true
                }
            }
        }
        }
    }

    init(url: URL) {
        self.url = url
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.showMinimizeCaret = true
            if !self.hasSeenSoundCloudMinimizeTooltip {
                self.showMinimizeToolTip = true
            }
        }
    }

    func dismissToolTip() {
        showMinimizeToolTip = false
        hasSeenSoundCloudMinimizeTooltip = true
    }
}
