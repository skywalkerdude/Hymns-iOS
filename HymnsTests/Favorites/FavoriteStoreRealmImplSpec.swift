import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class FavoriteStoreRealmImplSpec: QuickSpec {
    override func spec() {
        describe("using an in-memory realm") {
            var inMemoryRealm: Realm!
            var target: FavoriteStoreRealmImpl!
            beforeEach {
                // Don't worry about force_try in tests.
                // swiftlint:disable:next force_try
                inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "FavoriteStoreRealmImplSpec"))
                target = FavoriteStoreRealmImpl(realm: inMemoryRealm)
            }
            afterEach {
                // Don't worry about force_try in tests.
                // swiftlint:disable:next force_try
                try! inMemoryRealm.write {
                    inMemoryRealm.deleteAll()
                }
                inMemoryRealm.invalidate()
            }

            context("store a few favorites") {
                beforeEach {
                    target.storeFavorite(FavoriteEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151"))

                    target
                        .storeFavorite(FavoriteEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun"))

                    target
                        .storeFavorite(FavoriteEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014"))
                }
                describe("get the list of all favorites") {
                    it("should return a bool when we query if it is favorited") {

                        let queryAllTags = target.isFavorite(hymnIdentifier: cebuano123)
                        expect(queryAllTags).to(equal(true))
                    }
                    it("should be 3 when we query FavoriteEntity") {
                        let queryAllFavorites = target.favorites()
                        expect(queryAllFavorites).to(haveCount(3))
                    }
                }
            }
        }
    }
}
