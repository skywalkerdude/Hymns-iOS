import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnsRepositoryImplTests: XCTestCase {
    
    static let cebuano123: HymnIdentifier = HymnIdentifier(hymnType: .cebuano, hymnNumber: "123")
    static let hymn: Hymn = Hymn(title: "song title", metaData: [MetaDatum](), lyrics: [Verse]())
    
    var hymnalApiService: HymnalApiServiceMock!
    var target: HymnsRepository!
    
    override func setUp() {
        hymnalApiService = mock(HymnalApiService.self)
        target = HymnsRepositoryImpl(hymnalApiService: hymnalApiService)
    }
    
    func test_getHymn_resultsCached() {
        // Make one request to the API to store it in locally.
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> { Just<Hymn>(Self.hymn)
            .mapError({ (_) -> ErrorType in
                .network(description: "This will never get called")
            })
            .eraseToAnyPublisher()
        }
        var set = Set<AnyCancellable>()
        target.getHymn(hymnIdentifier: Self.cebuano123)
            .sink(receiveValue: { _ in })
            .store(in: &set)

        // Clear all invocations on the mock.
        clearInvocations(on: hymnalApiService)

        // Verify you still get the same result but without calling the API.
        var sinkTriggered = false
        target.getHymn(hymnIdentifier: Self.cebuano123)
            .sink(receiveValue: { hymn in
                sinkTriggered = true
                XCTAssertEqual(Self.hymn, hymn!)
            }).store(in: &set)

        XCTAssert(sinkTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasNeverCalled()
    }

    func test_getHymn_getFromNetwork_networkError() {
        var sinkTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> {
            Just<Hymn>(Self.hymn)
                .tryMap({ (_) -> Hymn in
                    throw URLError(.badServerResponse)
                })
                .mapError({ (_) -> ErrorType in
                    ErrorType.network(description: "forced network error")
                }).eraseToAnyPublisher()
        }

        var set = Set<AnyCancellable>()
        target.getHymn(hymnIdentifier: Self.cebuano123)
            .sink(receiveValue: { hymn in
                sinkTriggered = true
                XCTAssertNil(hymn)
            }).store(in: &set)

        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasCalled(exactly(1))

        XCTAssert(sinkTriggered)
    }

    func test_getHymn_getFromNetwork_resultsSuccessful() {
        var sinkTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> { Just<Hymn>(Self.hymn)
            .mapError({ (_) -> ErrorType in
                .network(description: "This will never get called")
            })
            .eraseToAnyPublisher()
        }

        var set = Set<AnyCancellable>()
        target.getHymn(hymnIdentifier: Self.cebuano123)
            .sink(receiveValue: { hymn in
                sinkTriggered = true
                XCTAssertEqual(Self.hymn, hymn!)
            }).store(in: &set)

        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)).wasCalled(exactly(1))

        XCTAssert(sinkTriggered)
    }

    func testPerformance_getHymn_resultsCached() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> { Just<Hymn>(Self.hymn)
            .mapError({ (_) -> ErrorType in
                .network(description: "This will never get called")
            })
            .eraseToAnyPublisher()
        }
        var set = Set<AnyCancellable>()
        target.getHymn(hymnIdentifier: Self.cebuano123)
            .sink(receiveValue: { _ in })
            .store(in: &set)

        self.measure {
            target.getHymn(hymnIdentifier: Self.cebuano123)
                .sink(receiveValue: { hymn in
                    XCTAssertEqual(Self.hymn, hymn!)
                }).store(in: &set)
        }
    }

    func testPerformance_getHymn_resultsSuccessful() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> { Just<Hymn>(Self.hymn)
            .mapError({ (_) -> ErrorType in
                .network(description: "This will never get called")
            })
            .eraseToAnyPublisher()
        }

        self.measure {
            var set = Set<AnyCancellable>()
            target.getHymn(hymnIdentifier: Self.cebuano123)
                .sink(receiveValue: { hymn in
                    XCTAssertEqual(Self.hymn, hymn!)
                }).store(in: &set)
        }
    }

    func testPerformance_getHymn_networkError() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil)) ~> {
            Just<Hymn>(Self.hymn)
                .tryMap({ (_) -> Hymn in
                    throw URLError(.badServerResponse)
                })
                .mapError({ (_) -> ErrorType in
                    ErrorType.network(description: "forced network error")
                }).eraseToAnyPublisher()
        }

        self.measure {
            var set = Set<AnyCancellable>()
            target.getHymn(hymnIdentifier: Self.cebuano123)
                .sink(receiveValue: { _ in })
                .store(in: &set)
        }
    }
}
