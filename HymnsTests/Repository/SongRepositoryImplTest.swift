import Combine
import Mockingbird
import XCTest
@testable import Hymns

class SongRepositoryImplTest: XCTestCase {

    static let resultsPage: SongResultsPage = SongResultsPage(results: [SongResult](), hasMorePages: false)

    var hymnalApiService: HymnalApiServiceMock!
    var target: SongResultsRepositoryImpl!

    override func setUp() {
        hymnalApiService = mock(HymnalApiService.self)
        target = SongResultsRepositoryImpl(hymnalApiService: hymnalApiService)
    }

    func test_search_networkError() {
        given(hymnalApiService.search(for: "Dan Sady", onPage: 2)) ~> {
            Just<SongResultsPage>(Self.resultsPage)
                .tryMap({ (_) -> SongResultsPage in
                    throw URLError(.badServerResponse)
                })
                .mapError({ (_) -> ErrorType in
                    ErrorType.network(description: "forced network error")
                }).eraseToAnyPublisher()
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.search(searchInput: "Dan Sady", pageNumber: 2)
            .sink(receiveValue: { resultsPage in
                valueReceived.fulfill()
                XCTAssertNil(resultsPage)
            })

        verify(hymnalApiService.search(for: "Dan Sady", onPage: 2)).wasCalled(exactly(1))
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_search_fromNtwork_resultsSuccessful() {
        given(hymnalApiService.search(for: "Dan Sady", onPage: 2)) ~> {
            Just<SongResultsPage>(Self.resultsPage)
                .mapError({ (_) -> ErrorType in
                    .network(description: "This will never get called")
                }).eraseToAnyPublisher()
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.search(searchInput: "Dan Sady", pageNumber: 2)
            .sink(receiveValue: { resultsPage in
                valueReceived.fulfill()
                XCTAssertEqual(Self.resultsPage, resultsPage!)
            })

        verify(hymnalApiService.search(for: "Dan Sady", onPage: 2)).wasCalled(exactly(1))
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

}
