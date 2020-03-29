import SwiftUI

var hymnTestData = ["Hymn 123", "Hymn 45", "God is Light", "Joy Unspeakable"]

struct DummyHymn: Identifiable {
    var id = UUID() //necessary to conform to identifiable protocol by showing each is an individual
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

#if DEBUB
var testData = [
    DummyHymn(songTitle: "JoyUnspeakable"),
    DummyHymn(hymnNumber: "Hymn 123"),
    DummyHymn(hymnNumber: "Hymn 45"),
]
#endif



