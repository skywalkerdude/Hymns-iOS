import SwiftUI
import RealmSwift
//swiftlint:disable force_try
//Need to disable linter since force try is standard practice with realm.

class RealmHelper {
    private static var realm = try! Realm()

    static func all() -> Results<FavoritedEntity> {
        return realm.objects(FavoritedEntity.self)
    }

    static func checkIfFavorite(identifier hymnIdentifier: HymnIdentifier) -> Bool {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificPerson = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)
        guard let favoritedHymn = specificPerson else {
            return false
        }
        return true
    }

    static func retrieveTitle(identifier hymnIdentifier: HymnIdentifier) -> String {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificHymn = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)
        guard let favoritedHymn = specificHymn else {
            return ""
        }
        return favoritedHymn.title
    }

    static func saveFavorite(identifier hymnIdentifier: HymnIdentifier, hymnTitle: String) {
        let hymn = FavoritedEntity()
        hymn.hymnType = hymnIdentifier.hymnType.abbreviatedValue
        hymn.hymnNumber = hymnIdentifier.hymnNumber
        hymn.favorited = true
        hymn.title = hymnTitle
        hymn.compoundKey = ("\(hymn.hymnType)\(hymn.hymnNumber)")
        try! realm.write {
            realm.add(hymn, update: .all)
        }
    }

    static func removeFavorite(identifier hymnIdentifier: HymnIdentifier) {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificHymn = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)
        try! realm.write {
            if let favoritedHymn = specificHymn {
                realm.delete(favoritedHymn)
            }
        }
    }
}
