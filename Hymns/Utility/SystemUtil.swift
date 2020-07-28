import Foundation
import SystemConfiguration

class SystemUtil {
    func isNetworkAvailable() -> Bool {
        if AppDelegate.networkMonitor.currentPath.status == .satisfied {
            return true
        } else {
            return false
        }
    }
}
