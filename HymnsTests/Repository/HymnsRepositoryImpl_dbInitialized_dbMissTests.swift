import Combine
import Mockingbird
import XCTest
@testable import Hymns

class HymnsRepositoryImpl_dbInitialized_dbMissTests: XCTestCase {

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
            Just(nil).mapError({ (_) -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
    }

    func test_getHymn_noNetwork() {
        given(systemUtil.isNetworkAvailable()) ~> false
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: nil)) ~> nil

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertNil(hymn)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(any())).wasNeverCalled()
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_networkAvailable_networkError() {
        given(systemUtil.isNetworkAvailable()) ~> true
        given(service.getHymn(cebuano123)) ~> { _ in
            Just(self.networkResult)
                .tryMap({ (_) -> Hymn in
                    throw URLError(.badServerResponse)
                })
                .mapError({ (_) -> ErrorType in
                    ErrorType.data(description: "forced network error")
                }).eraseToAnyPublisher()
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertNil(hymn)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_networkAvailable_resultsSuccessful() {
        given(systemUtil.isNetworkAvailable()) ~> true
        given(service.getHymn(cebuano123)) ~> {  _ in
            return Just(self.networkResult).mapError({ (_) -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
        given(converter.toHymnEntity(hymnIdentifier: cebuano123, hymn: self.networkResult)) ~> self.databaseResult
        given(converter.toUiHymn(hymnIdentifier: cebuano123, hymnEntity: self.databaseResult)) ~> self.expected

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertEqual(self.expected, hymn!)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(dataStore.saveHymn(self.databaseResult)).wasCalled(exactly(1))
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_getHymn_networkConversionError() {
        given(systemUtil.isNetworkAvailable()) ~> true
        given(service.getHymn(cebuano123)) ~> {  _ in
            Just(self.networkResult).mapError({ (_) -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
        }
        given(converter.toHymnEntity(hymnIdentifier: cebuano123, hymn: self.networkResult)) ~> {_, _ in
            throw TypeConversionError.init(triggeringError: ErrorType.parsing(description: "failed to convert!"))
        }

        let valueReceived = expectation(description: "value received")
        let cancellable = target.getHymn(cebuano123)
            .print(self.description)
            .sink(receiveValue: { hymn in
                valueReceived.fulfill()
                XCTAssertNil(hymn)
            })

        verify(dataStore.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(service.getHymn(cebuano123)).wasCalled(exactly(1))
        verify(dataStore.saveHymn(any())).wasNeverCalled()
        wait(for: [valueReceived], timeout: testTimeout)
        cancellable.cancel()
    }
}
