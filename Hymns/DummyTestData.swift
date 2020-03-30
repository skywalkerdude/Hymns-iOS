import SwiftUI

var hymnTestData = ["Hymn 123", "Hymn 45", "God is Light", "Joy Unspeakable"]

struct DummyHymn {
    var hymnType = ""
    var hymnNumber = ""
    //var queryParams if needed
    var songTitle = ""
    var songLyrics = ""
    var metaCategory = ""
    var metaSubCategory = ""
    var metaAuthor = ""
    var metaComposer = ""
    var metaKey = ""
    var metaTime = ""
    var metaMeter = ""
    var hymnCodeText = "" //idk what this is
    var metaScriptureText = ""
    
    //Not sure if this should be under the hymn object or not
    var favorited: Bool = false
}

struct DummyHymnView: Identifiable {
    var id = UUID() //necessary to conform to identifiable protocol by showing each is an individual
    var dummyHymn: DummyHymn
    
    var songTitle: String {
        return dummyHymn.songTitle
    }
    
    var hymnNumber: String {
        return dummyHymn.hymnNumber
    }
}

//#if DEBUG
let testData = [
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "JoyUnspeakable", songLyrics: "It is Joy unspeakable and full of glory, full of glory.")),
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 123")),
    DummyHymnView(dummyHymn: DummyHymn(hymnNumber: "Hymn 45")),
]
//#endif
