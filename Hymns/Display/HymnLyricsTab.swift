import Foundation
import SwiftUI

enum HymnLyricsTab {
    case lyrics(AnyView)
    case chords(AnyView)
    case guitar(AnyView)
    case piano(AnyView)
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

    var id: String { self.label }

    var content: AnyView {
        switch self {
        case .lyrics(let content):
            return content
        case .chords(let content):
            return content
        case .guitar(let content):
            return content
        case .piano(let content):
            return content
        }
    }

    var selectedLabel: some View {
        Text(label).font(.body).foregroundColor(.accentColor)
    }

    var unselectedLabel: some View {
        Text(label).font(.body).foregroundColor(.primary)
    }

    var a11yLabel: Text {
        Text(label)
    }

    static func == (lhs: HymnLyricsTab, rhs: HymnLyricsTab) -> Bool {
        lhs.label == rhs.label
    }
}

#if DEBUG
struct HymnLyricsTab_Previews: PreviewProvider {
    static var previews: some View {
        var lyricsTab: HymnLyricsTab = .lyrics(EmptyView().eraseToAnyView())
        var chordsTab: HymnLyricsTab = .chords(EmptyView().eraseToAnyView())
        var guitarTab: HymnLyricsTab = .guitar(EmptyView().eraseToAnyView())
        var pianoTab: HymnLyricsTab = .piano(EmptyView().eraseToAnyView())

        let currentTabLyrics = Binding<HymnLyricsTab>(
            get: {lyricsTab},
            set: {lyricsTab = $0})
        let missingChords = TabBar(currentTab: currentTabLyrics, tabItems: [lyricsTab, guitarTab, pianoTab])
        let lyricsSelected = TabBar(currentTab: currentTabLyrics, tabItems: [lyricsTab, chordsTab, guitarTab, pianoTab])

        let currentTabChords = Binding<HymnLyricsTab>(
            get: {chordsTab},
            set: {chordsTab = $0})
        let chordsSelected = TabBar(currentTab: currentTabChords, tabItems: [lyricsTab, chordsTab, guitarTab, pianoTab])

        let currentTabGuitar = Binding<HymnLyricsTab>(
            get: {guitarTab},
            set: {guitarTab = $0})
        let guitarSelected = TabBar(currentTab: currentTabGuitar, tabItems: [lyricsTab, chordsTab, guitarTab, pianoTab])

        let currentTabPiano = Binding<HymnLyricsTab>(
            get: {pianoTab},
            set: {pianoTab = $0})
        let pianoSelected = TabBar(currentTab: currentTabPiano, tabItems: [lyricsTab, chordsTab, guitarTab, pianoTab])

        return Group {
            missingChords.previewDisplayName("missing chords")
            lyricsSelected.previewDisplayName("lyrics selected")
            chordsSelected.previewDisplayName("chords selected")
            guitarSelected.previewDisplayName("guitar selected")
            pianoSelected.previewDisplayName("piano selected")
        }.previewLayout(.fixed(width: 450, height: 50))
    }
}
#endif
