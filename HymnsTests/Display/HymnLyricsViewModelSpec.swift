import Combine
import Quick
import Mockingbird
import Nimble
@testable import Hymns

class HymnLyricsViewModelSpec: QuickSpec {

    override func spec() {
        describe("HymnLyricsViewModel") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var target: HymnLyricsViewModel!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                target = HymnLyricsViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue)
            }
            context("with nil repository result") {
                context("result is completed") {
                    beforeEach {
                        given(hymnsRepository.getHymn(classic1151)) ~> {_ in
                            Just(nil).assertNoFailure().eraseToAnyPublisher()
                        }
                    }
                    describe("fetching lyrics") {
                        beforeEach {
                            target.fetchLyrics()
                            testQueue.sync {}
                        }
                        it("lyrics should be nil") {
                            expect(target.lyrics).to(beNil())
                        }
                        it("should call hymnsRepository.getHymn") {
                            verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                        }
                    }
                }
                context("result is not yet finished") {
                    let currentValue = CurrentValueSubject<UiHymn?, Never>(nil)
                    beforeEach {
                        given(hymnsRepository.getHymn(classic1151)) ~> {_ in
                            currentValue.eraseToAnyPublisher()
                        }
                    }
                    describe("fetching lyrics") {
                        beforeEach {
                            target.fetchLyrics()
                            testQueue.sync {}
                        }
                        it("lyrics should not be nil") {
                            expect(target.lyrics).toNot(beNil())
                        }
                        it("lyrics should not be empty") {
                            expect(target.lyrics).to(beEmpty())
                        }
                        it("should call hymnsRepository.getHymn") {
                            verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                        }
                        context("result finishes") {
                            beforeEach {
                                currentValue.send(completion: .finished)
                            }
                            it("lyrics should be nil") {
                                expect(target.lyrics).to(beNil())
                            }
                            it("should call hymnsRepository.getHymn") {
                                verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                            }
                        }
                    }
                }
            }
            context("with empty repository result") {
                beforeEach {
                    let emptyHymn = UiHymn(hymnIdentifier: classic1151, title: "Empty Hymn", lyrics: [Verse]())
                    given(hymnsRepository.getHymn(classic1151)) ~> {_ in Just(emptyHymn).assertNoFailure().eraseToAnyPublisher()}
                }
                describe("fetching lyrics") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                    }
                    it("lyrics should be empty") {
                        expect(target.lyrics).to(beNil())
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                }
            }
            context("with valid repository result") {
                let lyricsWithoutTransliteration: [Verse] = [
                    Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil),
                    Verse(verseType: .chorus, verseContent: ["chorus 1", "chorus 2"], transliteration: nil),
                    Verse(verseType: .other, verseContent: ["other 1", "other 2"], transliteration: nil),
                    Verse(verseType: .verse, verseContent: ["line 3", "line 4"], transliteration: nil)
                ]
                beforeEach {
                    let validHymn = UiHymn(hymnIdentifier: classic1151, title: "Filled Hymn", lyrics: lyricsWithoutTransliteration)
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in Just(validHymn).assertNoFailure().eraseToAnyPublisher()}
                }
                describe("fetching lyrics") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                    }
                    it("lyrics should be filled with lyrics") {
                        expect(target.lyrics).to(equal([
                            VerseViewModel(verseNumber: "1", verseLines: ["line 1", "line 2"]),
                            VerseViewModel(verseLines: ["chorus 1", "chorus 2"]),
                            VerseViewModel(verseLines: ["other 1", "other 2"]),
                            VerseViewModel(verseNumber: "2", verseLines: ["line 3", "line 4"])
                        ]))
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                }
            }
        }
    }
}
