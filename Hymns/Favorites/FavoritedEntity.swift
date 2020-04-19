import SwiftUI
import RealmSwift
//swiftlint:disable force_try
//Need to disable linter since force try is standard practice with realm.

//Realm model of a favorited hymn
class FavoritedEntity: Object, Identifiable {
    @objc dynamic var hymnType: String = ""
    @objc dynamic var hymnNumber: String = ""
    @objc dynamic var compoundKey = ""
    @objc dynamic var favorited = false
    @objc dynamic var title: String = ""

    func returnTitle() -> String {
        return self.title
    }

    override static func primaryKey() -> String? {
        return "compoundKey"
    }

    private static var realm = try! Realm()

    private func setup(hymnType: String, hymnNumber: String) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.compoundKey = compoundKeyValue()
    }

    private func compoundKeyValue() -> String {
        return "\(hymnType)\(hymnNumber)"
    }

    static func all() -> Results<FavoritedEntity> {
        realm.objects(FavoritedEntity.self)
    }

    static func checkIfFavorite(_ hymnType: String, _ hymnNumber: String) -> Bool {

        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificPerson = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)
        guard let favoritedHymn = specificPerson else {
            return false
        }
            return true
    }

    static func removeFavorite(hymnType: String, hymnNumber: String) {
        do {
            let realm = try Realm()
            let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
            let specificHymn = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)

            try! realm.write {
                if let favoritedHymn = specificHymn {
                    realm.delete(favoritedHymn)
                    print("delete success")
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }

    static func retrieveTitle(hymnType: String, hymnNumber: String) -> String {
        let realm = try! Realm()
        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificHymn = realm.object(ofType: FavoritedEntity.self, forPrimaryKey: myPrimaryKey)
        guard let favoritedHymn = specificHymn else {
            return ""
        }
        return favoritedHymn.title
    }

    static func saveFavorite(hymnType: String, hymnNumber: String, hymnTitle: String) {
        do {
            let realm = try Realm()
            let hymn = FavoritedEntity()
            hymn.hymnType = hymnType
            hymn.hymnNumber = hymnNumber
            hymn.favorited = true
            hymn.title = hymnTitle
            hymn.setup(hymnType: hymn.hymnType, hymnNumber: hymn.hymnNumber)
            try! realm.write {
                realm.add(hymn, update: .all)
                print("save success")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
