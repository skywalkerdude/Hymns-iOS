import Foundation
import Resolver

// swiftlint:disable all
class PreviewHymns {

    static var decoder: JSONDecoder {
        let decoder: JSONDecoder = Resolver.resolve()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static var classic1151 = getHymnFromJson(fileName: "classic1151")
    static var classic1334 = getHymnFromJson(fileName: "classic1334")

    static func getHymnFromJson(fileName: String) -> Hymn {
        let jsonPath = Bundle.main.path(forResource: fileName, ofType: "json")!
        let jsonString = try! String(contentsOfFile: jsonPath)
        let jsonData = jsonString.data(using: .utf8)!
        return try! decoder.decode(Hymn.self, from: jsonData)
    }
}
