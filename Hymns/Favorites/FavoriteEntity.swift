import SwiftUI
import RealmSwift

class FavoriteEntity: TagEntity {

    private static let favoriteTag = "_*_favorited_*_"

    required init() {
        super.init()
    }

    init(hymnIdentifier: HymnIdentifier, songTitle: String) {
        super.init(hymnIdentifier: hymnIdentifier, songTitle: songTitle, tag: Self.favoriteTag)
    }

    static func createPrimaryKey(hymnIdentifier: HymnIdentifier) -> String {
        return TagEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tag: favoriteTag)
    }
}
