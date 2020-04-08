import Foundation
import Resolver
@testable import Hymns

// swiftlint:disable all

class TestHymns{}

let decoder: JSONDecoder = Resolver.resolve()
let children24_json = getJsonString(for: "children24")
let children24_hymn = getHymnFromJson(for: "children24")

func getJsonString(for fileName: String) -> String {
    let jsonPath = Bundle(for: TestHymns.self).path(forResource: fileName, ofType: "json")!
    return try! String(contentsOfFile: jsonPath)
}

func getHymnFromJson(for fileName: String) -> Hymn {
    let jsonString = getJsonString(for: fileName)
    let jsonData = jsonString.data(using: .utf8)!
    return try! decoder.decode(Hymn.self, from: jsonData)
}
