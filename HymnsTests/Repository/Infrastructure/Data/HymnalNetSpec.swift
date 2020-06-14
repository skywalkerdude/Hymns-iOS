import Quick
import Nimble
import XCTest
@testable import Hymns

class HymnalNetSpec: QuickSpec {

    override func spec() {
        describe("getting the url") {
            context("empty path string") {
                it("should be nil") {
                    expect(HymnalNet.url(path: "")).to(beNil())
                }
            }
            context("invalid path string") {
                it("should be nil") {
                    expect(HymnalNet.url(path: "dfsafewa")).to(beNil())
                }
            }
            context("valid path string") {
                it("should create the correct url") {
                    expect(HymnalNet.url(path: "/en/hymn/h/1151/f=mid")!).to(equal(URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=mid")))
                }
            }
            context("valid path string with query params") {
                it("should create the correct url") {
                    expect(HymnalNet.url(path: "/en/hymn/h/1151/f=ppdf?gb=1")!).to(equal(URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=ppdf?gb=1")))
                }
            }
        }
    }
}
