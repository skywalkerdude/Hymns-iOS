import Foundation

/**
 * Structure of a Hymn object to be consumed by the UI.
 */
struct UiHymn: Equatable {
    typealias Title = String
    let hymnIdentifier: HymnIdentifier
    let title: String
    let lyrics: [Verse]
    let pdfSheet: MetaDatum?
    let category: String?
    let subcategory: String?
    let author: String?
    let languages: MetaDatum?
    let music: MetaDatum?
    let relevant: MetaDatum?
    // add more fields as needed
    /*
    func computedTitle(hymn: HymnIdentifier) -> String {
        let title: Title
        if hymn.hymnType == .classic {
            title = "Hymn \(hymn.hymnNumber)"
         } else {
            title = self.title.replacingOccurrences(of: "Hymn: ", with: "")
         }
         return title
    } */
    var computedTitle: String {
        let title: Title
        if hymnIdentifier.hymnType == .classic {
            title = "Hymn \(hymnIdentifier.hymnNumber)"
         } else {
            title = self.title.replacingOccurrences(of: "Hymn: ", with: "")
         }
         return title
}

    init(hymnIdentifier: HymnIdentifier, title: String, lyrics: [Verse], pdfSheet: MetaDatum? = nil,
         category: String? = nil, subcategory: String? = nil, author: String? = nil, languages: MetaDatum? = nil,
         music: MetaDatum? = nil, relevant: MetaDatum? = nil) {
        self.hymnIdentifier = hymnIdentifier
        self.title = title
        self.lyrics = lyrics
        self.pdfSheet = pdfSheet
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.languages = languages
        self.music = music
        self.relevant = relevant
    }
}
