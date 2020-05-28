import GRDB
import Quick
import Nimble
@testable import Hymns

class HymnDataStoreGrdbImpl_BrowseSpec: QuickSpec {

    override func spec() {
        describe("using an in-memory database queue") {
            var inMemoryDBQueue: DatabaseQueue!
            var target: HymnDataStoreGrdbImpl!
            beforeEach {
                // https://github.com/groue/GRDB.swift/blob/master/README.md#database-queues
                inMemoryDBQueue = DatabaseQueue()
                target = HymnDataStoreGrdbImpl(databaseQueue: inMemoryDBQueue, initializeTables: true)
            }
            describe("save songs with categories") {
                beforeEach {
                    target.saveHymn(HymnEntity(hymnIdentifier: classic1151, title: "classic 1151", category: "category 1", subcategory: "subcategory 1"))
                    target.saveHymn(HymnEntity(hymnIdentifier: newSong145, title: "new song 145", category: "category 1", subcategory: "subcategory 2"))
                    target.saveHymn(HymnEntity(hymnIdentifier: classic500, title: "classic 500", category: "category 1", subcategory: "subcategory 1"))
                    target.saveHymn(HymnEntity(hymnIdentifier: classic1109, title: "classic 1109", category: "category 2", subcategory: "subcategory 2"))
                }
                describe("getting all categories") {
                    it("should contain categories with their counts") {
                        let completion = XCTestExpectation(description: "completion received")
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getAllCategories()
                            .print(self.description)
                            .sink(receiveCompletion: { state in
                                completion.fulfill()
                                expect(state).to(equal(.finished))
                            }, receiveValue: { categories in
                                value.fulfill()
                                expect(categories).to(haveCount(3))
                                expect(categories[0]).to(equal(CategoryEntity(category: "category 1", subcategory: "subcategory 1", count: 2)))
                                expect(categories[1]).to(equal(CategoryEntity(category: "category 1", subcategory: "subcategory 2", count: 1)))
                                expect(categories[2]).to(equal(CategoryEntity(category: "category 2", subcategory: "subcategory 2", count: 1)))
                            })
                        self.wait(for: [completion, value], timeout: testTimeout)
                        publisher.cancel()
                    }
                }
                describe("getting all classic categories") {
                    it("should contain categories with their counts") {
                        let completion = XCTestExpectation(description: "completion received")
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getCategories(by: .classic)
                            .print(self.description)
                            .sink(receiveCompletion: { state in
                                completion.fulfill()
                                expect(state).to(equal(.finished))
                            }, receiveValue: { categories in
                                value.fulfill()
                                expect(categories).to(haveCount(2))
                                expect(categories[0]).to(equal(CategoryEntity(category: "category 1", subcategory: "subcategory 1", count: 2)))
                                expect(categories[1]).to(equal(CategoryEntity(category: "category 2", subcategory: "subcategory 2", count: 1)))
                            })
                        self.wait(for: [completion, value], timeout: testTimeout)
                        publisher.cancel()
                    }
                }
            }
        }
    }
}
