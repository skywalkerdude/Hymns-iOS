import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnLyricsViewModelTest: XCTestCase {

    static let classic1151: HymnIdentifier = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")
    static let emptyHymn: Hymn = Hymn(title: "Empty Hymn", metaData: [MetaDatum](), lyrics: [Verse]())
    static let lyricsWithoutTransliteration: [Verse] = [Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil)]
    static let filledHymn: Hymn = Hymn(title: "Filled Hymn", metaData: [MetaDatum](), lyrics: lyricsWithoutTransliteration)
    
    var hymnsRepository: HymnsRepositoryMock!
    var target: HymnLyricsViewModel!
    
    override func setUp() {
        hymnsRepository = mock(HymnsRepository.self)
    }
    
    func test_init_repositoryCallFailed() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(nil).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertNil(target.lyrics)
    }

    func test_init_repositoryReturnsEmptyLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(Self.emptyHymn).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertNil(target.lyrics)
    }

    func test_init_repositoryReturnsLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(Self.filledHymn).assertNoFailure().eraseToAnyPublisher()}

        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)

        verify(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)).wasCalled(exactly(1))
        XCTAssertNotNil(target.$lyrics)
        XCTAssertEqual(Self.lyricsWithoutTransliteration, target.lyrics)
    }

    func testPerformance_init() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.classic1151)) ~> {Just(Self.filledHymn).assertNoFailure().eraseToAnyPublisher()}

        self.measure {
            target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)
        }
    }
}
