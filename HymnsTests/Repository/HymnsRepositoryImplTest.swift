import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnsRepositoryImplTests: XCTestCase {

    static let hymn: Hymn = Hymn(title: "song title", metaData: [MetaDatum](), lyrics: [Verse]())

    var hymnalApiService: HymnalApiServiceMock!
    var target: HymnsRepository!

    override func setUp() {
        super.setUp()
        hymnalApiService = mock(HymnalApiService.self)
        target = HymnsRepositoryImpl(hymnalApiService: hymnalApiService)
    }

    func test_getHymn_resultsCached() {
        // Make one request to the API to store it in locally.
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> {
            Just<Hymn>(Self.hymn)
                .mapError({ (_) -> ErrorType in
                    .network(description: "This will never get called")
                })
                .eraseToAnyPublisher()
        }
        var set = Set<AnyCancellable>()
        target.getHymn(hymnIdentifier: cebuano123)
            .sink(receiveValue: { _ in })
            .store(in: &set)

        // Clear all invocations on the mock.
        clearInvocations(on: hymnalApiService)

        // Verify you still get the same result but without calling the API.
        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(hymnIdentifier: cebuano123)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertEqual(Self.hymn, hymn!)
            })

        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasNeverCalled()
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_getFromNetwork_networkError() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> {
            Just<Hymn>(Self.hymn)
                .tryMap({ (_) -> Hymn in
                    throw URLError(.badServerResponse)
                })
                .mapError({ (_) -> ErrorType in
                    ErrorType.network(description: "forced network error")
                }).eraseToAnyPublisher()
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(hymnIdentifier: cebuano123)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertNil(hymn)
            })

        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasCalled(exactly(1))
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_getFromNetwork_resultsSuccessful() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> { Just<Hymn>(Self.hymn)
            .mapError({ (_) -> ErrorType in
                .network(description: "This will never get called")
            })
            .eraseToAnyPublisher()
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(hymnIdentifier: cebuano123)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertEqual(Self.hymn, hymn!)
            })

        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasCalled(exactly(1))
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }
}
