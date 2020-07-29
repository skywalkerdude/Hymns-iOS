import Foundation
import SystemConfiguration

class SystemUtil {
    func isNetworkAvailable() -> Bool {
        return AppDelegate.networkMonitor.currentPath.status == .satisfied
    }
}
