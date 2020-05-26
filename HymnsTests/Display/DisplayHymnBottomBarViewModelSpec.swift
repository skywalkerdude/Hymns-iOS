import Quick
import Nimble
import Mockingbird
import Combine
@testable import Hymns

// swiftlint:disable:next type_name
class DisplayHymnBottomBarViewModelSpec: QuickSpec {

    override func spec() {
        describe("DisplayHymnBottomBarViewModel") {
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var target: DisplayHymnBottomBarViewModel!

            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
            }
            describe("init") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, backgroundQueue: testQueue)
                }
                it("should set up the info dialog") {
                    expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                }
                it("shareable lyrics should be an empty string") {
                    expect(target.shareableLyrics).to(equal(""))
                }
            }
            context("with nil repository result and hymn 1151") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, backgroundQueue: testQueue)
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(nil).assertNoFailure().eraseToAnyPublisher()
                    }
                }
                describe("performing fetch") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                        testQueue.sync {}
                        testQueue.sync {}
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                    it("shareable lyrics should be an empty string") {
                        expect(target.shareableLyrics).to(equal(""))
                    }
                }
            }
            context("fetch hymn 1151 with valid repository") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, backgroundQueue: testQueue)
                }
                context("with empty lyrics") {
                    beforeEach {
                        let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse]())
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(hymn).assertNoFailure().eraseToAnyPublisher()
                        }
                    }
                    describe("performing fetch") {
                        beforeEach {
                            target.fetchLyrics()
                            testQueue.sync {}
                            testQueue.sync {}
                            testQueue.sync {}
                        }
                        it("should call hymnsRepository.getHymn") {
                            verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                        }
                        it("shareable lyrics should be an empty string") {
                            expect(target.shareableLyrics).to(equal(""))
                        }
                    }
                }
                context("fetch hymn 1151 with valid repository") {
                    context("with hymn1151 lyrics") {
                        beforeEach {
                            let lyricsWithoutTransliteration: [Verse] = [
                                Verse(verseType: .verse, verseContent: ["Drink! a river pure and clear that's flowing from the throne;", "Eat! the tree of life with fruits abundant, richly grown"], transliteration: nil),
                                Verse(verseType: .chorus, verseContent: ["Do come, oh, do come,", "Says Spirit and the Bride:"], transliteration: nil)
                            ]
                            let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: lyricsWithoutTransliteration)
                            given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                                Just(hymn).assertNoFailure().eraseToAnyPublisher()
                            }
                        }
                        describe("performing fetch") {
                            beforeEach {
                                target.fetchLyrics()
                                testQueue.sync {}
                                testQueue.sync {}
                                testQueue.sync {}
                            }
                            it("should call hymnsRepository.getHymn") {
                                verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                            }
                            it("shareable lyrics should be Drink a river") {
                                expect(target.shareableLyrics).to(equal("Drink! a river pure and clear that's flowing from the throne;\nEat! the tree of life with fruits abundant, richly grown\n\nDo come, oh, do come,\nSays Spirit and the Bride:\n\n"))
                            }
                        }
                    }
                }
            }
        }
    }
}
