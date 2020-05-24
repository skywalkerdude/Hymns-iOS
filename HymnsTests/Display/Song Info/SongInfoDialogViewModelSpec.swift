import Combine
import Quick
import Mockingbird
import Nimble
@testable import Hymns

class SongInfoDialogViewModelSpec: QuickSpec {

    override func spec() {
        describe("SongInfoDialogViewModel") {
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var target: SongInfoDialogViewModel!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
            }
            describe("fetchSongInfo") {
                beforeEach {
                    target = SongInfoDialogViewModel(backgroundQueue: testQueue, hymnToDisplay: classic1151,
                                                     hymnsRepository: hymnsRepository, mainQueue: testQueue)
                }
                context("nil repository result") {
                    beforeEach {
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(nil).assertNoFailure().eraseToAnyPublisher()
                        }
                        target.fetchSongInfo()
                    }
                    it("song info should be empty") {
                        expect(target.songInfo).to(beEmpty())
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                }
                context("with empty repository results") {
                    beforeEach {
                        let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse]())
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(hymn).assertNoFailure().eraseToAnyPublisher()
                        }
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(nil).assertNoFailure().eraseToAnyPublisher()
                        }
                        target.fetchSongInfo()
                    }
                    it("song info should be empty") {
                        expect(target.songInfo).to(beEmpty())
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                }
                context("with valid repository results") {
                    beforeEach {
                        let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse](), category: "category",
                                          subcategory: "subcategory1;subcategory2", author: "Will Jeng;  ;\n;Titus Ting;")
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(hymn).assertNoFailure().eraseToAnyPublisher()
                        }
                        target.fetchSongInfo()
                        testQueue.sync {}
                        testQueue.sync {}
                        testQueue.sync {}
                    }
                    it("song info should be filled") {
                        expect(target.songInfo).to(haveCount(3))
                        let expected = [SongInfoViewModel(label: "Category", values: ["category"]),
                                        SongInfoViewModel(label: "Subcategory", values: ["subcategory1", "subcategory2"]),
                                        SongInfoViewModel(label: "Author", values: ["Will Jeng", "Titus Ting"])]
                        expect(target.songInfo).to(equal(expected))
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                }
            }
        }
    }
}
