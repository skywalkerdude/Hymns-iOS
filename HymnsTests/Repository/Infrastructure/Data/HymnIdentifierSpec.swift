import Quick
import Nimble
@testable import Hymns

class HymnIdentifierSpec: QuickSpec {

    override func spec() {
        describe("serialize to query param string") {
            it("should serialize an empty dictionary to nil") {
                expect([String: String]().serializeToQueryParamString).to(beNil())
            }
            it("should serialize a one-item dictionary properly") {
                expect(["key1": "value1"].serializeToQueryParamString).to(equal("?key1=value1"))
            }
            it("should serialize a multi-item dictionary properly") {
                let str = ["key1": "value1", "key2": "value2"].serializeToQueryParamString!
                expect(str).to(haveCount(24))
                expect(str[str.startIndex]).to(equal("?"))
                expect(str).to(contain("key1=value1"))
                expect(str[str.index(str.startIndex, offsetBy: 12)]).to(equal("&"))
                expect(str).to(contain("key2=value2"))
            }
        }
        describe("deserialize to query param dictionary") {
            it("should deserialize an empty string to nil") {
                expect("".deserializeFromQueryParamString).to(beNil())
            }
            it("should serialize a one-item query string properly") {
                let dict = "?key1=value1".deserializeFromQueryParamString!
                expect(dict).to(haveCount(1))
                expect(dict["key1"]).to(equal("value1"))
            }
            it("should serialize a multi-item query string properly") {
                let dict = "?key1=value1&key2=value2".deserializeFromQueryParamString!
                expect(dict).to(haveCount(2))
                expect(dict["key1"]).to(equal("value1"))
                expect(dict["key2"]).to(equal("value2"))
            }
            it("should serialize an invalid query param to nil") {
                expect("?key1&key2=value2".deserializeFromQueryParamString).to(beNil())
                expect("?key1=value1=value3&key2=value2".deserializeFromQueryParamString).to(beNil())
            }
        }
    }
}
