import SwiftUI
import Resolver
import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter {$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

/**
 * Protocol wrapper for `UIApplication` for ease of testing.
 */
protocol Application {
    func open(_ url: URL)
}

class ApplicationImpl: Application {

    private let application = UIApplication.shared

    func open(_ url: URL) {
        application.open(url)
    }
}

extension Resolver {
    static func registerApplication() {
        register {ApplicationImpl() as Application}.scope(application)
    }
}
