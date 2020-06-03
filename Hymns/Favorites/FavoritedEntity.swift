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

    init(hymnIdentifier: HymnIdentifier, songTitle: String, tags: String) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: tags)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = songTitle
        self.tags = tags
    }

    init(hymnIdentifier: HymnIdentifier, tags: String) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: tags)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = ""
        self.tags = tags
    }

    override static func primaryKey() -> String? {
        return "primaryKey"
    }

    static func createPrimaryKey(hymnIdentifier: HymnIdentifier, tags: String) -> String {
        return ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]())" + tags)
    }
}
