import Combine
import Quick
import Mockingbird
import Nimble
@testable import Hymns

class HymnLyricsViewModelSpec: QuickSpec {

    override func spec() {
        let classic1151 = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")

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
                let lyricsWithoutTransliteration: [Verse] = [Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil)]
                beforeEach {
                    let validHymn = Hymn(title: "Filled Hymn", metaData: [MetaDatum](), lyrics: lyricsWithoutTransliteration)
                    given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(validHymn).assertNoFailure().eraseToAnyPublisher()}
                }
                describe("fetching lyrics") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                    }
                    it("lyrics should be empty") {
                        expect(target.lyrics).to(equal(lyricsWithoutTransliteration))
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                    }
                }
            }
        }
    }
}
