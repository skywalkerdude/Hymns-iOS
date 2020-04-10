import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnLyricsViewModelTest: XCTestCase {

    static let classic1151: HymnIdentifier = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")
    static let emptyHymn: Hymn = Hymn(title: "Empty Hymn", metaData: [MetaDatum](), lyrics: [Verse]())
    static let lyricsWithoutTransliteration: [Verse] = [Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil)]
    static let filledHymn: Hymn = Hymn(title: "Filled Hymn", metaData: [MetaDatum](), lyrics: lyricsWithoutTransliteration)

    // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
    var testQueue: DispatchQueue = DispatchQueue(label: "test_queue")
    var hymnsRepository: HymnsRepositoryMock!
    var target: HymnLyricsViewModel!

    override func setUp() {
        super.setUp()
        hymnsRepository = mock(HymnsRepository.self)
    }

    func test_init_repositoryCallFailed() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(nil).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnToDisplay: Self.classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertNil(target.lyrics)
    }

    func test_init_repositoryReturnsEmptyLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(Self.emptyHymn).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnToDisplay: Self.classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertNil(target.lyrics)
    }

    func test_init_repositoryReturnsLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(Self.filledHymn).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnToDisplay: Self.classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertEqual(Self.lyricsWithoutTransliteration, target.lyrics)
    }
}
