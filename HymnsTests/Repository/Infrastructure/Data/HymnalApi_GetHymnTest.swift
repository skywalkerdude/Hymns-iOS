import Combine
import Resolver
import XCTest
@testable import Hymns

class HymnalApiService_GetHymnTest: XCTestCase {

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

    func test_networkError() {

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

    func test_decodeError() {

        // Stub mock to return a valid network response but an invalid json.
        URLProtocolMock.testURLs = [Self.children24: Data("".utf8)]
        URLProtocolMock.response = createValidResponse(for: Self.children24)

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

    func test_validResponse() {

        // Stub mock to return a valid network response but an invalid json.
        URLProtocolMock.testURLs = [Self.children24: Data(children_24_json.utf8)]
        URLProtocolMock.response = createValidResponse(for: Self.children24)

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
                        XCTAssertEqual(children_24_hymn, hymn)
                        return
                })
        wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
        cancellable.cancel()
    }

    func test_validResponse_withQueryParams() {

        // Stub mock to return a valid network response but an invalid json.
        URLProtocolMock.testURLs = [Self.children24QueryParams: Data(children_24_json.utf8)]
        URLProtocolMock.response = createValidResponse(for: Self.children24)

        let failureExpectation = expectation(description: "Invalid.failure")
        failureExpectation.isInverted = true
        let finishedExpectation = expectation(description: "Invalid.finished")
        let receiveExpectation = expectation(description: "Invalid.receiveValue")

        let cancellable
            = target.getHymn(hymnType: .children, hymnNumber: "24", queryParams: ["key1": "value1"])
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
                        XCTAssertEqual(children_24_hymn, hymn)
                        return
                })
        wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
        cancellable.cancel()
    }
}

extension HymnalApiService_GetHymnTest {
    static let children24 = URL(string: "http://hymnalnetapi.herokuapp.com/v2/hymn/c/24")!
    static let children24QueryParams = URL(string: "http://hymnalnetapi.herokuapp.com/v2/hymn/c/24?key1=value1")!
}
