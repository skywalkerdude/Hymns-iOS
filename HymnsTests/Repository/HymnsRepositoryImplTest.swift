import XCTest
import Mockingbird
@testable import Hymns

class HymnsRepositoryImplTests: XCTestCase {
    
    let hymnIdentifier: HymnIdentifier = HymnIdentifier(hymnType: .cebuano, hymnNumber: "123")
    let hymn: Hymn = Hymn(title: "song title", metaData: [MetaDatum](), lyrics: [Verse]())
    
    var hymnalApiService: HymnalApiServiceMock!
    var target: HymnsRepository!
    
    override func setUp() {
        hymnalApiService = mock(HymnalApiService.self)
        target = HymnsRepositoryImpl(hymnalApiService: hymnalApiService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getHymn_getFromLocalStore() {
        // Make one request to the API to store it in locally.
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(self.hymn)
        }
        target.getHymn(hymnIdentifier: self.hymnIdentifier) { hymn in
            XCTAssertEqual(self.hymn, hymn)
        }
        // Clear all invocations on the mock.
        clearInvocations(on: hymnalApiService)
        
        // Verify you still get the same result but without calling the API.
        var callbackTriggered = false
        target.getHymn(hymnIdentifier: self.hymnIdentifier) { hymn in
            callbackTriggered = true
            XCTAssertNotNil(hymn)
            XCTAssertEqual(self.hymn, hymn!)
        }
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasNeverCalled()
    }
    
    func getHymn_getFromNetwork_resultsMissing() {
        var callbackTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(nil)
        }
        
        target.getHymn(hymnIdentifier: self.hymnIdentifier) { hymn in
            callbackTriggered = true
            XCTAssertNil(hymn)
        }
        
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasCalled(exactly(1))
    }
    
    func getHymn_getFromNetwork_resultsSuccessful() {
        var callbackTriggered = false
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(self.hymn)
        }
        
        target.getHymn(hymnIdentifier: self.hymnIdentifier) { hymn in
            callbackTriggered = true
            XCTAssertNotNil(hymn)
            XCTAssertEqual(self.hymn, hymn!)
        }
        
        XCTAssert(callbackTriggered)
        verify(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())).wasCalled(exactly(1))
    }
    
    func testPerformanceExample() {
        given(hymnalApiService.getHymn(hymnType: .cebuano, hymnNumber: "123", queryParams: nil, any())) ~> { (hymnType, hymnNumber, queryParams, callback) in
            callback(self.hymn)
        }
        
        self.measure {
            target.getHymn(hymnIdentifier: self.hymnIdentifier) { hymn in
                assert(self.hymn == hymn!)
            }
        }
    }
}
