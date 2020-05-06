import Foundation
import Resolver
@testable import Hymns

// swiftlint:disable all

class TestHymns{}

let cebuano123 = HymnIdentifier(hymnType: .cebuano, hymnNumber: "123")
let children24 = HymnIdentifier(hymnType: .children, hymnNumber: "24")
let classic1151 = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")
let newSong145 = HymnIdentifier(hymnType: .newSong, hymnNumber: "145")

let decoder: JSONDecoder = Resolver.resolve()
let children_24_json = getJsonString(for: "children_24")
let children_24_hymn = getHymnFromJson(for: "children_24")
let children_24_hymn_entity = HymnEntity(hymnIdentifier: children24, title: Optional("Hymn: He Didn’t Stay Home"), lyricsJson: Optional("[{\"verse_type\":\"verse\",\"verse_content\":[\"He didn’t stay home;\",\"He went and visited people.\",\"He didn’t stay home;\",\"Jesus taught disciples.\",\"Fed the following crowd outdoors;\",\"Made them glad forevermore;\",\"Serving’s what His life was for;\",\"He didn’t stay home. SO!!!!!\"]},{\"verse_type\":\"verse\",\"verse_content\":[\"Don’t stay home! (go, go!)\",\"Go and visit people!\",\"Don’t stay home! (go, go!)\",\"Go and teach disciples. (GO!)\",\"Fix some food, go out the door;\",\"Make them glad forevermore;\",\"Serving is what life is for,\",\"So DON’T STAY HOME!!\"]},{\"verse_type\":\"other\",\"verse_content\":[\"\\n\",\"© 2012 Bible StorySongs, Inc. Used by permission.\",\"Visit BibleStorySongs.com to order CD’s & Sheet Music.\",\"\\n\"]}]"), category: Optional("Preaching of the Gospel"), subcategory: Optional("Go Ye!"), author: Optional("P. K.C. R. W."), composer: Optional("Traditional (1908)"), key: Optional("E Major"), time: Optional("4/4"), meter: nil, scriptures: nil, hymnCode: Optional("5332153322172"), musicJson: Optional("{\"name\":\"Music\",\"data\":[{\"value\":\"mp3\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=mp3\"},{\"value\":\"MIDI\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=mid\"},{\"value\":\"Tune (MIDI)\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=tune\"}]}"), svgSheetJson: Optional("{\"name\":\"svg\",\"data\":[{\"value\":\"Piano\",\"path\":\"https:\\/\\/www.hymnal.net\\/Hymns\\/Children\\/svg\\/child0024_p.svg\"},{\"value\":\"Guitar\",\"path\":\"https:\\/\\/www.hymnal.net\\/Hymns\\/Children\\/svg\\/child0024_g.svg\"}]}"), pdfSheetJson: Optional("{\"name\":\"Lead Sheet\",\"data\":[{\"value\":\"Piano\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=ppdf\"},{\"value\":\"Guitar\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=pdf\"},{\"value\":\"Text\",\"path\":\"\\/en\\/hymn\\/c\\/24\\/f=gtpdf\"}]}"), languagesJson: nil, relevantJson: nil)
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
