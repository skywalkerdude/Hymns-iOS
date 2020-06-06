import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class TagListViewModelSpec: QuickSpec {
    override func spec() {
        describe("using an in-memory realm") {
            var tagStore: TagStoreMock!
            var target: TagListViewModel!
            beforeEach {
                tagStore = mock(TagStore.self)
                target = TagListViewModel(tagStore: tagStore)
            }
            context("store a few tags") {
                beforeEach {
                    given(tagStore.getUniqueTags()) ~> ["tag 1", "tag 2", "tag 3", "tag 1"]
                }
                it("should contain only unique tag names") {
                    target.getUniqueTags()
                    expect(target.tags).to(equal(["tag 1", "tag 2", "tag 3", "tag 1"]))
                }
            }
        }
    }
}
