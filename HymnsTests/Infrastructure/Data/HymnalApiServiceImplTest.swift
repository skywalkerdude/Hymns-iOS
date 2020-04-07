import Combine
import Resolver
import XCTest
@testable import Hymns

class HymnalApiServiceImplTest: XCTestCase {

    static  let children24 = URL(string: "http://hymnalnetapi.herokuapp.com/v2/hymn/c/24")!
    static let validResponse = HTTPURLResponse(url: children24,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)

    var protocolMock: URLProtocolMock!
    var target: HymnalApiServiceImpl!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        target = HymnalApiServiceImpl(decoder: Resolver.resolve(), session: session)
    }

    override func tearDown() {
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [URL?: Data]()
    }

    func testGetHymn_networkError() {

        // Stub mock to return a network error.
        URLProtocolMock.error = ErrorType.network(description: "network error!")

        let failureExpectation = expectation(description: "Invalid.failure")
        let finishedExpectation = expectation(description: "Invalid.finished")
        finishedExpectation.isInverted = true
        let receiveExpectation = expectation(description: "Invalid.receiveValue")
        receiveExpectation.isInverted = true

        let cancellable
            = target.getHymn(hymnType: .children, hymnNumber: "24", queryParams: nil)
                .sink(
                    receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                        switch completion {
                        case .failure(let error):
                            XCTAssertEqual(error.localizedDescription, "Error ocurred when making a network request")
                            failureExpectation.fulfill()
                        case .finished:
                            finishedExpectation.fulfill()
                        }
                        return
                },
                    receiveValue: { _ in
                        receiveExpectation.fulfill()
                        return
                })
        wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
        cancellable.cancel()
    }

    func testGetHymn_decodeError() {

        // Stub mock to return a valid network response but an invalid json.
        URLProtocolMock.testURLs = [HymnalApiServiceImplTest.children24: Data("".utf8)]
        URLProtocolMock.response = Self.validResponse

        let failureExpectation = expectation(description: "Invalid.failure")
        let finishedExpectation = expectation(description: "Invalid.finished")
        finishedExpectation.isInverted = true
        let receiveExpectation = expectation(description: "Invalid.receiveValue")
        receiveExpectation.isInverted = true

        let cancellable
            = target.getHymn(hymnType: .children, hymnNumber: "24", queryParams: nil)
                .sink(
                    receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                        switch completion {
                        case .failure(let error):
                            XCTAssertEqual(error.localizedDescription, "Error occured when parsing a network response")
                            failureExpectation.fulfill()
                        case .finished:
                            finishedExpectation.fulfill()
                        }
                        return
                },
                    receiveValue: { _ in
                        receiveExpectation.fulfill()
                        return
                })
        wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
        cancellable.cancel()
    }

    func testGetGetHymn_validResponse() {

        // Stub mock to return a valid network response but an invalid json.
        URLProtocolMock.testURLs = [HymnalApiServiceImplTest.children24: Data(children24_json.utf8)]
        URLProtocolMock.response = Self.validResponse

        let failureExpectation = expectation(description: "Invalid.failure")
        failureExpectation.isInverted = true
        let finishedExpectation = expectation(description: "Invalid.finished")
        let receiveExpectation = expectation(description: "Invalid.receiveValue")

        let cancellable
            = target.getHymn(hymnType: .children, hymnNumber: "24", queryParams: nil)
                .sink(
                    receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                        switch completion {
                        case .failure:
                            failureExpectation.fulfill()
                        case .finished:
                            finishedExpectation.fulfill()
                        }
                },
                    receiveValue: { hymn in
                        receiveExpectation.fulfill()
                        XCTAssertEqual(children24_hymn, hymn)
                        return
                })
        wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
        cancellable.cancel()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
