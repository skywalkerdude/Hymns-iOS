import Foundation
import Network
import Resolver

protocol SystemUtil {
    func isNetworkAvailable() -> Bool

    /**
     * We define a small screen to be a screen with width less than or equal to 350 pixels.
     */
    func isSmallScreen() -> Bool
}

class SystemUtilImpl: SystemUtil {

    private let networkMonitor: NWPathMonitor

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        networkMonitor = NWPathMonitor()
        networkMonitor.start(queue: backgroundQueue)
    }

    func isNetworkAvailable() -> Bool {
        return networkMonitor.currentPath.status == .satisfied
    }

    func isSmallScreen() -> Bool {
        return UIScreen.main.bounds.width <= 350
    }
}
