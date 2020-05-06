import Foundation

/**
 * Represents a single point of meta data for a hymn. It consists of a name and data associated with that name.
 */
struct MetaDatum: Codable, Equatable {
    let name: String
    let data: [Datum]
}

enum MetaDatumName: String {
    case category
    case subcategory
    case author
    case composer
    case key
    case time
    case meter
    case hymnCode
    case scriptures
    case music
    case svgSheet
    case pdfSheet
    case languages
    case relevant
}

extension MetaDatumName {
    var jsonKey: String {
        switch self {
        case .category:
            return "Category"
        case .subcategory:
            return "Subcategory"
        case .author:
            return "Lyrics"
        case .composer:
            return "Music"
        case .key:
            return "Key"
        case .time:
            return "Time"
        case .meter:
            return "Meter"
        case .hymnCode:
            return "Hymn Code"
        case .scriptures:
            return "Scriptures"
        case .music:
            return "Music"
        case .svgSheet:
            return "svg"
        case .pdfSheet:
            return "Lead Sheet"
        case .languages:
            return "Languages"
        case .relevant:
            return "Relevant"
        }
    }
}
