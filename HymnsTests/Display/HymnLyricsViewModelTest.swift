import XCTest
import Mockingbird
@testable import Hymns

class HymnLyricsViewModelTest: XCTestCase {
    
    static let cebuano123: HymnIdentifier = HymnIdentifier(hymnType: .cebuano, hymnNumber: "123")
    static let emptyHymn: Hymn = Hymn(title: "Empty Hymn", metaData: [MetaDatum](), lyrics: [Verse]())
    static let lyricsWithoutTransliteration: [Verse] = [Verse(verseType: .verse, verseContent: ["line 1", "line 2"], transliteration: nil)]
    static let filledHymn: Hymn = Hymn(title: "Filled Hymn", metaData: [MetaDatum](), lyrics: lyricsWithoutTransliteration)
    
    var hymnsRepository: HymnsRepositoryMock!
    var target: HymnLyricsViewModel!
    
    override func setUp() {
        hymnsRepository = mock(HymnsRepository.self)
    }
    
    func init_repositoryReturnsNil() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())) ~> { (hymnIdentifier, callback) in
            callback(nil)
        }
        
        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)
        
        verify(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())).wasCalled(exactly(1))
        XCTAssertNil(target.$lyrics)
    }
    
    func init_repositoryReturnsEmptyLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())) ~> { (hymnIdentifier, callback) in
            callback(Self.emptyHymn)
        }
        
        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)
        
        verify(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())).wasCalled(exactly(1))
        XCTAssertNil(target.$lyrics)
    }
    
    func init_repositoryReturnsLyrics() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())) ~> { (hymnIdentifier, callback) in
            callback(Self.filledHymn)
        }
        
        target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)
        
        verify(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())).wasCalled(exactly(1))
        XCTAssertNotNil(target.$lyrics)
        XCTAssertEqual(Self.lyricsWithoutTransliteration, target.lyrics)
    }

    func testPerformance() {
        given(hymnsRepository.getHymn(hymnIdentifier: Self.cebuano123, any())) ~> { (hymnIdentifier, callback) in
            callback(Self.filledHymn)
        }
        
        self.measure {
            target = HymnLyricsViewModel(hymnsRepository: hymnsRepository)
        }
    }

}
