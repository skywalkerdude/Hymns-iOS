import Foundation

/**
 * Structure of a Hymn object to be consumed by the UI.
 */
struct UiHymn: Equatable {
    let hymnIdentifier: HymnIdentifier
    let title: String
    let lyrics: [Verse]
    let pdfSheet: MetaDatum?
    let musicJson: MetaDatum?
    // add more fields as needed

    init(hymnIdentifier: HymnIdentifier, title: String, lyrics: [Verse], pdfSheet: MetaDatum? = nil, musicJson: MetaDatum? = nil) {
        self.hymnIdentifier = hymnIdentifier
        self.title = title
        self.lyrics = lyrics
        self.pdfSheet = pdfSheet
        self.musicJson = musicJson
    }
}
