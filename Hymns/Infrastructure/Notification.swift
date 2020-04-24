import Foundation
import RealmSwift

extension NotificationToken {
    func toNotification() -> Notification {
        NotificationImpl(notificationToken: self) as Notification
    }
}

/**
 * Protocol wapper for `NotificationToken` for ease of testing.
 */
protocol Notification {
    func invalidate()
}

class NotificationImpl: Notification {
    private let notificationToken: NotificationToken

    init(notificationToken: NotificationToken) {
        self.notificationToken = notificationToken
    }

    func invalidate() {
        notificationToken.invalidate()
    }
}
