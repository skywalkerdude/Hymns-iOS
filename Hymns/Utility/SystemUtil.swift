import Foundation
import Network
import Resolver

class SystemUtil {

    private let networkMonitor: NWPathMonitor

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background")) {
        networkMonitor = NWPathMonitor()
        networkMonitor.start(queue: backgroundQueue)
    }

    func isNetworkAvailable() -> Bool {
        return networkMonitor.currentPath.status == .satisfied
    }
}
