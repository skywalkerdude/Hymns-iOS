import SwiftUI

//model to represent one hymn object
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

//the view model to interact with our hymn model
struct DummyHymnView: Identifiable {
    var id = UUID()
    var dummyHymn: DummyHymn
    
    var songTitle: String {
        return dummyHymn.songTitle
    }
    
    var hymnNumber: String {
        return dummyHymn.hymnNumber
    }
    
    var favorited: Bool = false
}

#if DEBUG
let testData = [
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "JoyUnspeakable", songLyrics: "It is Joy unspeakable and full of glory, full of glory."), favorited: true),
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 123")),    DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 480")),   DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 20")),   DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 123")),   DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 89")),   DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 16")),
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "What about my sinful past")),
    DummyHymnView(dummyHymn: DummyHymn(songTitle: "Hymn 98")),
    DummyHymnView(dummyHymn: DummyHymn( hymnNumber: "Hymn 45", songTitle: "Hymn 45"))
]
#endif
