import SwiftUI

enum HymnLyricsTab: String {
    case lyrics
    case chords
    case guitar
    case piano
}

extension HymnLyricsTab {
    var label: String {
        switch self {
        case .lyrics:
            return "Lyrics"
        case .chords:
            return "Chords"
        case .guitar:
            return "Guitar"
        case .piano:
            return "Piano"
        }
    }
}

extension HymnLyricsTab: HymnLyricsTabItem {

var id: HymnLyricsTab { self }

var hymnTabLabel: some View {
        return Text(label)
    }

var a11yLabel: Text {
    switch self {
    case .lyrics:
        return Text("lyrics")
    case .guitar:
        return Text("guitar")
    case .chords:
        return Text("chords")
    case .piano:
        return Text("piano")
    }
}
}
