import SwiftUI
import RealmSwift
import Combine
// swiftlint:disable force_try
//Need to disable linter since force try is standard practice with realm.

//Mixture of Combine and Realm notifications to push db updates to the UI
class Store: ObservableObject {
    var objectWillChange: ObservableObjectPublisher = .init()
    private(set) var itemEntities: Results<FavoritedHymn> = FavoritedHymn.all()
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

//Realm model of a favorited hymn
class FavoritedHymn: Object, Identifiable {
    @objc dynamic var hymnType: String = ""
    @objc dynamic var hymnNumber: String = ""
    @objc dynamic var compoundKey = ""
    @objc dynamic var favorited = false

    override static func primaryKey() -> String? {
        return "compoundKey"
    }

    private static var realm = try! Realm()

    private func setup(hymnType: String, hymnNumber: String, favorited: Bool) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.compoundKey = compoundKeyValue()
    }

    private func compoundKeyValue() -> String {
        return "\(hymnType)\(hymnNumber)"
    }

    static func all() -> Results<FavoritedHymn> {
        realm.objects(FavoritedHymn.self)
    }

    static func checkIfFavorite(_ hymnType: String, _ hymnNumber: String) -> Bool {

        let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
        let specificPerson = realm.object(ofType: FavoritedHymn.self, forPrimaryKey: myPrimaryKey)
        if let obj = specificPerson {
            return true
        } else {
            return false
        }
    }

    static func removeFavorite(hymnType: String, hymnNumber: String) {
        do {
            let realm = try Realm()

            let myPrimaryKey = ("\(hymnType)\(hymnNumber)")
            let specificPerson = realm.object(ofType: FavoritedHymn.self, forPrimaryKey: myPrimaryKey)

            try! realm.write {
                if let obj = specificPerson {
                    realm.delete(obj)
                    print("delete success")
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }

    static func saveFavorite(hymnType: String, hymnNumber: String) {
        do {
            let realm = try Realm()
            let hymn = FavoritedHymn()
            hymn.hymnType = hymnType
            hymn.hymnNumber = hymnNumber
            hymn.favorited = true
            hymn.setup(hymnType: hymn.hymnType, hymnNumber: hymn.hymnNumber, favorited: hymn.favorited)
            try! realm.write {
                realm.add(hymn, update: .all)
                print("save success")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
