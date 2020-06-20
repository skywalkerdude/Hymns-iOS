import Foundation
@testable import Hymns

class Hymns{}

let hymn1151_hymn = getHymnFromJson(fileName: "classic_1151")
let hymn1334_hymn = getHymnFromJson(fileName: "classic_1334")

func getHymnFromJson(fileName: String) -> Hymn {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let jsonPath = Bundle(for: Hymns.self).path(forResource: fileName, ofType: "json")!
    let jsonString = try! String(contentsOfFile: jsonPath)
    let jsonData = jsonString.data(using: .utf8)!
    return try! decoder.decode(Hymn.self, from: jsonData)
}

