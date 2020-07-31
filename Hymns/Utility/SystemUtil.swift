import Foundation
import Network
import Resolver

protocol SystemUtil {
    func isNetworkAvailable() -> Bool
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
}
