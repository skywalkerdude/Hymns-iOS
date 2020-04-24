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
                beforeEach {
                    given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(nil).assertNoFailure().eraseToAnyPublisher()}
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
                        verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                    }
                }
            }
            context("with empty repository result") {
                beforeEach {
                    let emptyHymn = Hymn(title: "Empty Hymn", metaData: [MetaDatum](), lyrics: [Verse]())
                    given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(emptyHymn).assertNoFailure().eraseToAnyPublisher()}
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
                        verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
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
                    let validHymn = Hymn(title: "Filled Hymn", metaData: [MetaDatum](), lyrics: lyricsWithoutTransliteration)
                    given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(validHymn).assertNoFailure().eraseToAnyPublisher()}
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
                        verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                    }
                }
            }
        }
    }
}
