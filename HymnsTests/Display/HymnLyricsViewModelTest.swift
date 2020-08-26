import Combine
import Quick
import Mockingbird
import Nimble
import XCTest
@testable import Hymns

class HymnLyricsViewModelTest: XCTestCase {

    // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
    let testQueue = DispatchQueue(label: "test_queue")
    var hymnsRepository: HymnsRepositoryMock!
    var target: HymnLyricsViewModel!

    override func setUp() {
        super.setUp()
        hymnsRepository = mock(HymnsRepository.self)
        target = HymnLyricsViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue)
        target.shouldRepeatChorus = false
    }

    func test_withNilRepositoryResult_resultCompleted() throws {
        given(hymnsRepository.getHymn(classic1151)) ~> {_ in
            Just(nil).assertNoFailure().eraseToAnyPublisher()
        }

        target.fetchLyrics()
        testQueue.sync {}

        expect(self.target.lyrics).to(beNil())
        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
    }

    func test_withNilRepositoryResult_resultNotYetFinished() throws {
        let currentValue = CurrentValueSubject<UiHymn?, Never>(nil)
        given(hymnsRepository.getHymn(classic1151)) ~> {_ in
            currentValue.eraseToAnyPublisher()
        }

        target.fetchLyrics()
        testQueue.sync {}

        expect(self.target.lyrics).toNot(beNil())
        expect(self.target.lyrics).to(beEmpty())
        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))

        // Result finishes
        currentValue.send(completion: .finished)
        testQueue.sync {}

        expect(self.target.lyrics).to(beNil())
        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
    }

    func test_withEmptyRepositoryResult() throws {
        let emptyHymn = UiHymn(hymnIdentifier: classic1151, title: "Empty Hymn", lyrics: [Verse]())
        given(hymnsRepository.getHymn(classic1151)) ~> {_ in Just(emptyHymn).assertNoFailure().eraseToAnyPublisher()}

        target.fetchLyrics()
        testQueue.sync {}

        expect(self.target.lyrics).to(beNil())
        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
    }

    func test_withValidRepositoryResult() throws {
        let lyricsWithoutTransliteration: [Verse] = [
            Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil),
            Verse(verseType: .chorus, verseContent: ["chorus 1", "chorus 2"], transliteration: nil),
            Verse(verseType: .other, verseContent: ["other 1", "other 2"], transliteration: nil),
            Verse(verseType: .verse, verseContent: ["line 3", "line 4"], transliteration: nil)
        ]
        let validHymn = UiHymn(hymnIdentifier: classic1151, title: "Filled Hymn", lyrics: lyricsWithoutTransliteration)
        given(hymnsRepository.getHymn(classic1151)) ~> { _ in Just(validHymn).assertNoFailure().eraseToAnyPublisher()}

        target.fetchLyrics()
        testQueue.sync {}

        expect(self.target.lyrics).to(equal([
            VerseViewModel(verseNumber: "1", verseLines: ["line 1", "line 2"]),
            VerseViewModel(verseLines: ["chorus 1", "chorus 2"]),
            VerseViewModel(verseLines: ["other 1", "other 2"]),
            VerseViewModel(verseNumber: "2", verseLines: ["line 3", "line 4"])
        ]))

        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
    }
}
