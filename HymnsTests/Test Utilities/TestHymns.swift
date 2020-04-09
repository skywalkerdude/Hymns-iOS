import Foundation
import Resolver
@testable import Hymns

// swiftlint:disable all

class TestHymns{}

let decoder: JSONDecoder = Resolver.resolve()
let children_24_json = getJsonString(for: "children_24")
let children_24_hymn = getHymnFromJson(for: "children_24")
let search_drink_json = getJsonString(for: "search_drink")
let search_drink_song_result_page = getSongResultPageFromJson(for: "search_drink")
let search_drink_page_3_json = getJsonString(for: "search_drink_page_3")
let search_drink_page_3_song_result_page = getSongResultPageFromJson(for: "search_drink_page_3")
let search_drink_page_10_json = getJsonString(for: "search_drink_page_10")
let search_drink_page_10_song_result_page = getSongResultPageFromJson(for: "search_drink_page_10")

func getJsonString(for fileName: String) -> String {
    let jsonPath = Bundle(for: TestHymns.self).path(forResource: fileName, ofType: "json")!
    return try! String(contentsOfFile: jsonPath)
}

func getHymnFromJson(for fileName: String) -> Hymn {
    return getModelFromJson(for: fileName, as: Hymn.self)
}

func getSongResultPageFromJson(for fileName: String) -> SongResultsPage {
    return getModelFromJson(for: fileName, as: SongResultsPage.self)
}

func getModelFromJson<ModelType: Decodable>(for fileName: String, as modelType: ModelType.Type) -> ModelType {
    let jsonString = getJsonString(for: fileName)
    let jsonData = jsonString.data(using: .utf8)!
    return try! decoder.decode(ModelType.self, from: jsonData)
}
