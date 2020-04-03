import XCTest
import Mockingbird
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
    
    func test_getHymn_getFromLocalStore() {
        // Make one request to the API to store it in locally.
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(Self.hymn)
        }
        target.getHymn(hymnIdentifier: Self.cebuano123) { hymn in
            XCTAssertEqual(Self.hymn, hymn)
        }
        // Clear all invocations on the mock.
        clearInvocations(on: hymnalApiService)
        
        // Verify you still get the same result but without calling the API.
        var callbackTriggered = false
        target.getHymn(hymnIdentifier: Self.cebuano123) { hymn in
            callbackTriggered = true
            XCTAssertNotNil(hymn)
            XCTAssertEqual(Self.hymn, hymn!)
        }
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasNeverCalled()
    }
    
    func test_getHymn_getFromNetwork_resultsMissing() {
        var callbackTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(nil)
        }
        
        target.getHymn(hymnIdentifier: Self.cebuano123) { hymn in
            callbackTriggered = true
            XCTAssertNil(hymn)
        }
        
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasCalled(exactly(1))
    }
    
    func test_getHymn_getFromNetwork_resultsSuccessful() {
        var callbackTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(Self.hymn)
        }
        
        target.getHymn(hymnIdentifier: Self.cebuano123) { hymn in
            callbackTriggered = true
            XCTAssertNotNil(hymn)
            XCTAssertEqual(Self.hymn, hymn!)
        }
        
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasCalled(exactly(1))
    }
    
    func testPerformance_getHymn() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(Self.hymn)
        }
        
        self.measure {
            target.getHymn(hymnIdentifier: Self.cebuano123) { hymn in
                assert(Self.hymn == hymn!)
            }
        }
    }
}
