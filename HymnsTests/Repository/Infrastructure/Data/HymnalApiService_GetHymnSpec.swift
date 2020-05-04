import Combine
import Quick
import Mockingbird
import Nimble
import Resolver
@testable import Hymns

class HymnalApiService_GetHymnSpec: QuickSpec {

    override func spec() {
        describe("HymnalApi_GetHymnSpec") {
            var target: HymnalApiServiceImpl!
            beforeEach {
                let config = URLSessionConfiguration.ephemeral
                config.protocolClasses = [URLProtocolMock.self]
                let session = URLSession(configuration: config)
                target = HymnalApiServiceImpl(decoder: Resolver.resolve(), session: session)
            }
            afterEach {
                URLProtocolMock.response = nil
                URLProtocolMock.error = nil
                URLProtocolMock.testURLs = [URL?: Data]()
            }
            context("with network error") {
                beforeEach {
                    // Stub mock to return a network error.
                    URLProtocolMock.error = ErrorType.data(description: "network error!")
                }
                it("only the failure completion callback should be triggered") {
                    let failureExpectation = self.expectation(description: "Invalid.failure")
                    let finishedExpectation = self.expectation(description: "Invalid.finished")
                    finishedExpectation.isInverted = true
                    let receiveExpectation = self.expectation(description: "Invalid.receiveValue")
                    receiveExpectation.isInverted = true

                    let cancellable
                        = target.getHymn(children24)
                            .sink(
                                receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                                    switch completion {
                                    case .failure(let error):
                                        expect(error.localizedDescription).to(equal("Error occurred when making a network request"))
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
                    self.wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
                    cancellable.cancel()
                }
            }
            context("with decode error") {
                beforeEach {
                    // Stub mock to return a valid network response but an invalid json.
                    URLProtocolMock.response = self.createValidResponse(for: Self.children24URL)
                    URLProtocolMock.testURLs = [Self.children24URL: Data("".utf8)]
                }
                it("only the failure completion callback should be triggered") {
                    let failureExpectation = self.expectation(description: "Invalid.failure")
                    let finishedExpectation = self.expectation(description: "Invalid.finished")
                    finishedExpectation.isInverted = true
                    let receiveExpectation = self.expectation(description: "Invalid.receiveValue")
                    receiveExpectation.isInverted = true

                    let cancellable
                        = target.getHymn(children24)
                            .sink(
                                receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                                    switch completion {
                                    case .failure(let error):
                                        expect(error.localizedDescription).to(equal("Error occurred when parsing a network response"))
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
                    self.wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
                    cancellable.cancel()
                }
            }
            context("with a valid response") {
                beforeEach {
                    // Stub mock to return a valid network response but an invalid json.
                    URLProtocolMock.response = self.createValidResponse(for: Self.children24URL)
                    URLProtocolMock.testURLs = [Self.children24URL: Data(children_24_json.utf8)]
                }
                it("the finished completion and receive value callbacks should be triggered") {
                    let failureExpectation = self.expectation(description: "Invalid.failure")
                    failureExpectation.isInverted = true
                    let finishedExpectation = self.expectation(description: "Invalid.finished")
                    let receiveExpectation = self.expectation(description: "Invalid.receiveValue")

                    let cancellable
                        = target.getHymn(children24)
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
                                    expect(hymn).to(equal(children_24_hymn))
                                    return
                            })
                    self.wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
                    cancellable.cancel()
                }
            }
            context("with a valid response and the request contains query paramters") {
                beforeEach {
                    // Stub mock to return a valid network response but an invalid json.
                    URLProtocolMock.response = self.createValidResponse(for: Self.children24URL)
                    URLProtocolMock.testURLs = [Self.children24QueryParamsURL: Data(children_24_json.utf8)]
                }
                it("the finished completion and receive value callbacks should be triggered") {
                    let failureExpectation = self.expectation(description: "Invalid.failure")
                    failureExpectation.isInverted = true
                    let finishedExpectation = self.expectation(description: "Invalid.finished")
                    let receiveExpectation = self.expectation(description: "Invalid.receiveValue")

                    let identifier = HymnIdentifier(hymnType: .children, hymnNumber: "24", queryParams: ["key1": "value1"])
                    let cancellable
                        = target.getHymn(identifier)
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
                                    expect(hymn).to(equal(children_24_hymn))
                                    return
                            })
                    self.wait(for: [failureExpectation, finishedExpectation, receiveExpectation], timeout: testTimeout)
                    cancellable.cancel()
                }
            }
        }
    }
}

extension HymnalApiService_GetHymnSpec {
    static let children24URL = URL(string: "http://hymnalnetapi.herokuapp.com/v2/hymn/c/24")!
    static let children24QueryParamsURL = URL(string: "http://hymnalnetapi.herokuapp.com/v2/hymn/c/24?key1=value1")!
}
