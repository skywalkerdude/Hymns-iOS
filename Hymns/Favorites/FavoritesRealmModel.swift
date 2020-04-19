import SwiftUI
import RealmSwift
import Combine

//Mixture of Combine and Realm notifications to push db updates to the UI
class Store: ObservableObject {
    var objectWillChange: ObservableObjectPublisher = .init()
    private(set) var itemEntities: Results<FavoritedEntity> = FavoritedEntity.all()
    private var notificationTokens: [NotificationToken] = []

    init() {
        notificationTokens.append(itemEntities.observe { _ in
            self.objectWillChange.send()
        })
    }

    deinit {
        notificationTokens.forEach { $0.invalidate() }
    }
}
