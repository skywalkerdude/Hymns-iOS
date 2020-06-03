import SwiftUI
import RealmSwift

class FavoriteEntity: Object, Identifiable {
    @objc dynamic var primaryKey: String!
    @objc dynamic var hymnIdentifierEntity: HymnIdentifierEntity!
    @objc dynamic var songTitle: String!
    @objc dynamic var tags: String!

    required init() {
        super.init()
    }
//TODO: delete this init if not needed later
    init(hymnIdentifier: HymnIdentifier, songTitle: String, tags: String) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = songTitle
        self.tags = tags
    }

    init(hymnIdentifier: HymnIdentifier, songTitle: String) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = songTitle
    }

    init(hymnIdentifier: HymnIdentifier) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = ""
    }

    override static func primaryKey() -> String? {
        return "primaryKey"
    }

    static func createPrimaryKey(hymnIdentifier: HymnIdentifier) -> String {
        return "\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]())"
    }
}
