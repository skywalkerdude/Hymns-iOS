import SwiftUI
import RealmSwift

/** Realm model of a favorited hymn */
class FavoritedEntity: Object, Identifiable {
    @objc dynamic var hymnType: String = ""
    @objc dynamic var hymnNumber: String = ""
    @objc dynamic var compoundKey = ""
    @objc dynamic var favorited = false
    @objc dynamic var title: String = ""

    override class func primaryKey() -> String? {
        return "compoundKey"
    }
}
