import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnsRepositoryImpl_dbInitialized_dbHitTests: XCTestCase {

    let databaseResult = HymnEntity(hymnIdentifier: cebuano123,
                                    id: 0,
                                    title: "song title",
                                    lyricsJson: "[{\"verse_type\":\"verse\",\"verse_content\":[\"line 1\",\"line 2\"]}]")
    let networkResult = Hymn(title: "song title", metaData: [MetaDatum](), lyrics: [Verse(verseType: .verse, verseContent: ["line 1", "line 2"])])
    let expected = UiHymn(hymnIdentifier: cebuano123, title: "song title", lyrics: [Verse(verseType: .verse, verseContent: ["line 1", "line 2"])])

    var backgroundQueue = DispatchQueue.init(label: "background test queue")
    var converter: ConverterMock!
    var dataStore: HymnDataStoreMock!
    var service: HymnalApiServiceMock!
    var systemUtil: SystemUtilMock!
    var target: HymnsRepository!

    override func setUp() {
        super.setUp()
        converter = mock(Converter.self)
        dataStore = mock(HymnDataStore.self)
        service = mock(HymnalApiService.self)
        systemUtil = mock(SystemUtil.self)
        target = HymnsRepositoryImpl(converter: converter, dataStore: dataStore, mainQueue: backgroundQueue, service: service, systemUtil: systemUtil)
        given(dataStore.getDatabaseInitializedProperly()) ~> true
        given(dataStore.getHymn(cebuano123)) ~> { _ in
            Just(self.databaseResult).mapError({ _ -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
    }

    func test_getHymn_resultsCached() {
        given(systemUtil.isNetworkAvailable()) ~> false
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> self.expected

        var set = Set<AnyCancellable>()
        // Make one request to store it the memcache.
        target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveValue: { _ in })
            .store(in: &set)

        backgroundQueue.sync {}

        // Clear all invocations on the mock.
        clearInvocations(on: dataStore)
        clearInvocations(on: service)

        // Verify you still get the same result but without calling the API.
        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertEqual(self.expected, hymn!)
            })

        verify(dataStore.getHymn(any())).wasNeverCalled()
        verify(service.getHymn(any())).wasNeverCalled()
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_noNetwork() {
        given(dataStore.getHymn(cebuano123)) ~> { _ in
            Just(self.databaseResult).mapError({ _ -> ErrorType in
                .data(description: "This will never get called")
            }).subscribe(on: self.backgroundQueue).eraseToAnyPublisher()
            // Test asynchronous data store call as well to make sure the loading values are being dropped
        }
        given(systemUtil.isNetworkAvailable()) ~> false
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> self.expected

        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertEqual(self.expected, hymn!)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(any())).wasNeverCalled()
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_networkAvailable_resultsSuccessful() {
        given(systemUtil.isNetworkAvailable()) ~> true
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> self.expected

        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertEqual(self.expected, hymn!)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(any())).wasNeverCalled()
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_databaseConversionError_noNetwork() {
        given(systemUtil.isNetworkAvailable()) ~> false
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> { _, _ in
            throw TypeConversionError.init(triggeringError: ErrorType.parsing(description: "failed to convert!"))
        }

        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertNil(hymn)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(any())).wasNeverCalled()
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_databaseConversionNil_networkAvailable() {
        given(systemUtil.isNetworkAvailable()) ~> true
        given(service.getHymn(cebuano123)) ~> {  _ in
            Just(self.networkResult).mapError({ _ -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> nil
        given(converter.toHymnEntity(hymnIdentifier: cebuano123, hymn: self.networkResult)) ~> self.databaseResult

        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        value.expectedFulfillmentCount = 2
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertNil(hymn)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(dataStore.saveHymn(self.databaseResult)).wasCalled(exactly(1))
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }

    // Cannot do until https://github.com/birdrides/mockingbird/issues/111 is resolved, since we are try to
    // make converter.toUiHymn throw an error the first time and execute sucessfully the second time.
    func ignored_test_getHymn_databaseConversionError_networkAvailable_resultsSuccessful() {
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> { _, _ in
            throw TypeConversionError.init(triggeringError: ErrorType.parsing(description: "failed to convert!"))
        }
        given(systemUtil.isNetworkAvailable()) ~> true
        given(service.getHymn(cebuano123)) ~> {  _ in
            return Just(self.networkResult).mapError({ _ -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
        given(converter.toHymnEntity(hymnIdentifier: cebuano123, hymn: self.networkResult)) ~> self.databaseResult
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> self.expected

        let completion = expectation(description: "completion received")
        let value = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveCompletion: { state in
                completion.fulfill()
                XCTAssertEqual(state, .finished)
            }, receiveValue: { hymn in
                value.fulfill()
                XCTAssertEqual(self.expected, hymn!)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(dataStore.saveHymn(self.databaseResult)).wasCalled(exactly(1))
        wait(for: [completion, value], timeout: testTimeout)
        cancellable.cancel()
    }
}
