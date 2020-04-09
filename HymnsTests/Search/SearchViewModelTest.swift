import Combine
import Mockingbird
import XCTest
@testable import Hymns

class SearchViewModelTest: XCTestCase {

    static let classic594 = SongResult(name: "classic594", path: "/en/hymn/h/594?gb=1&query=3")
    static let noHymnType = SongResult(name: "noHymnType", path: "")
    static let newTune7 = SongResult(name: "newTune7", path: "/en/hymn/nt/7")
    static let noHymnNumber = SongResult(name: "noHymnNumber", path: "/en/hymn/h/a")
    static let songResultsPage = SongResultsPage(results: [classic594, noHymnType, newTune7, noHymnNumber], hasMorePages: true)

    var testQueue = DispatchQueue(label: "test_queue")
    var songResultsRepository: SongResultsRepositoryMock!
    var target: SearchViewModel!

    override func setUp() {
        songResultsRepository = mock(SongResultsRepository.self)
    }

    func test_initialCall_dropped() {
        let searchExpectation = expectation(description: "search triggered")
        searchExpectation.isInverted = true
        given(songResultsRepository.search(searchInput: any(), pageNumber: any())) ~> { searchInput, pageNumber in
            searchExpectation.fulfill()
            return Just(Self.songResultsPage).eraseToAnyPublisher()
        }

        target = SearchViewModel(backgroundQueue: testQueue, mainQueue: testQueue, repository: songResultsRepository)

        wait(for: [searchExpectation], timeout: testTimeout)
        verify(songResultsRepository.search(searchInput: any(), pageNumber: any())).wasNeverCalled()
    }

    func test_performSearch_error() {
        let searchExpectation = expectation(description: "search triggered")
        given(songResultsRepository.search(searchInput: "Minrou Chen", pageNumber: 1)) ~> { searchInput, pageNumber in
            searchExpectation.fulfill()
            return Just(nil).eraseToAnyPublisher()
        }

        target = SearchViewModel(backgroundQueue: testQueue, mainQueue: testQueue, repository: songResultsRepository)
        target.searchInput = "Minrou Chen"

        wait(for: [searchExpectation], timeout: testTimeout)
        verify(songResultsRepository.search(searchInput: any(), pageNumber: any())).wasCalled(exactly(1))

        testQueue.sync {}
        XCTAssertEqual(target.songResults.count, 0)
    }

    func test_performSearch() {
        // dummy expectation to force the test to take the full second, or else there are race conditions that cause the assertion to take place
        // prior to target.songResults being set by the callback.
        let dummyExpectation = expectation(description: "dummy expectation")
        dummyExpectation.isInverted = true
        let searchExpectation = expectation(description: "search triggered")
        given(songResultsRepository.search(searchInput: "Minrou Chen", pageNumber: 1)) ~> { searchInput, pageNumber in
            searchExpectation.fulfill()
            return Just(Self.songResultsPage).eraseToAnyPublisher()
        }

        target = SearchViewModel(backgroundQueue: testQueue, mainQueue: testQueue, repository: songResultsRepository)
        target.searchInput = "Minrou Chen"

        wait(for: [searchExpectation, dummyExpectation], timeout: testTimeout)
        verify(songResultsRepository.search(searchInput: any(), pageNumber: any())).wasCalled(exactly(1))

        testQueue.sync {}
        XCTAssertEqual(target.songResults.count, 2)
        XCTAssertEqual(target.songResults[0].title, "classic594")
        XCTAssertEqual(target.songResults[1].title, "newTune7")
    }
}
