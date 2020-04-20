import SwiftUI
import RealmSwift
import Combine

//Mixture of Combine and Realm notifications to push db updates to the UI
//Hard to find resources for this so here is a link to the foreign site to understand implementation.
//https://qiita.com/chocoyama/items/af172b32f492b706c96d#observableobject%E3%82%92%E5%88%A9%E7%94%A8%E3%81%99%E3%82%8B

class FavoritesViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    private(set) var itemEntities: Results<FavoritedEntity> = RealmHelper.all()
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
