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

extension HymnLyricsTab: TabItem {

var id: HymnLyricsTab { self }

    //HOW CAN I PASS IN VARIABLES THROUGH AN ENUM?! Like view model or urls? 
var content: some View {
    switch self {
    case .lyrics:
        return                 HymnLyricsView(viewModel: HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)).eraseToAnyView()
    case .guitar:
        return                 WebView(url: URL(string: "http://www.google.com")).eraseToAnyView()

    case .chords:
        return                 WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")).eraseToAnyView()

    case .piano:
        return                 WebView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")).eraseToAnyView()

    }
}
    
    var selectedLabel: some View {
        return Text(label)
    }

    var unselectedLabel: some View {
        return Text(label)
    }

var a11yLabel: Text {
    switch self {
    case .lyrics:
        return Text("Search tab")
    case .guitar:
        return Text("Favorites tab")
    case .chords:
        return Text("Browse tab")
    case .piano:
        return Text("Settings tab")
    }
}
}
