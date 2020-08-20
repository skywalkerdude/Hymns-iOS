import Foundation

/**
 * Represents the type of a hymn.
 */
@objc enum HymnType: Int {
    case classic
    case newTune
    case newSong
    case children
    case scripture
    case howardHigashi
    case dutch
    case german
    case chinese
    case chineseSupplement
    case cebuano
    case tagalog
    case french
    // Song types added from H4A
    case spanish
    case korean
    case japanese

    static var allCases: [HymnType] {
        return [classic, newTune, newSong, children, scripture, howardHigashi,
                dutch, german, chinese, chineseSupplement, cebuano, tagalog,
                french, spanish, korean, japanese]
    }
}

extension HymnType {
    var abbreviatedValue: String {
        switch self {
        case .classic:
            return "h"
        case .newTune:
            return "nt"
        case .newSong:
            return "ns"
        case .children:
            return "c"
        case .scripture:
            return "sc"
        case .howardHigashi:
            return "lb"
        case .dutch:
            return "hd"
        case .german:
            return "de"
        case .chinese:
            return "ch"
        case .chineseSupplement:
            return "ts"
        case .cebuano:
            return "cb"
        case .tagalog:
            return "ht"
        case .french:
            return "hf"
        case .spanish:
            return "S"
        case .korean:
            return "K"
        case .japanese:
            return "J"
        }
    }

    /**
     * The number of songs in the category from Hymnal.net.
     *
     * Note: Certain hymn types don't have a max number because they are not continuous (i.e. new tunes, different languages, etc).
     */
    var maxNumber: Int {
        switch self {
        case .classic:
            return 1360
        case .newSong:
            return 722
        case .children:
            return 181
        case .howardHigashi:
            return 87
        case .chinese:
            return 1111
        case .chineseSupplement:
            return 1005
        default:
            return 0
        }
    }

    /**
     * Maps a HymnType's abbreciated value to the corresponding enum.
     *
     * - Parameters:
     *     - abbreviatedValue: abbreviated value of the enum
     * - Returns: HymnType corresponding to value
     */
    static func fromAbbreviatedValue(_ abbreviatedValue: String) -> HymnType? {
        for hymnType in HymnType.allCases where abbreviatedValue == hymnType.abbreviatedValue {
            return hymnType
        }
        return nil
    }

    var displayValue: String {
        switch self {
        case .classic:
            return NSLocalizedString("Classic hymns", comment: "Display name of 'Classic hymns', usually appears just by itself (i.e. as a title)")
        case .newTune:
            return NSLocalizedString("New tunes", comment: "Display name of 'New tunes'. Usually appears just by itself (i.e. as a title)")
        case .newSong:
            return NSLocalizedString("New songs", comment: "Display name of 'New songs'. Usually appears just by itself (i.e. as a title)")
        case .children:
            return NSLocalizedString("Children's songs", comment: "Display name of 'Children's songs'. Usually appears just by itself (i.e. as a title)")
        case .scripture:
            return NSLocalizedString("Scripture songs", comment: "Display name of 'Scripture songs'. Usually appears just by itself (i.e. as a title)")
        case .howardHigashi:
            return NSLocalizedString("Howard Higashi songs", comment: "Display name of 'Howard Higashi songs'. Usually appears just by itself (i.e. as a title)")
        case .dutch:
            return NSLocalizedString("Dutch hymns", comment: "Display name of 'Dutch hymns'. Usually appears just by itself (i.e. as a title)")
        case .german:
            return NSLocalizedString("German hymns", comment: "Display name of 'German hymns'. Usually appears just by itself (i.e. as a title)")
        case .chinese:
            return NSLocalizedString("Chinese hymns", comment: "Display name of 'Chinese hymns'. Usually appears just by itself (i.e. as a title)")
        case .chineseSupplement:
            return NSLocalizedString("Chinese supplemental hymns", comment: "Display name of 'Chinese supplemental hymns'. Usually appears just by itself (i.e. as a title)")
        case .cebuano:
            return NSLocalizedString("Cebuano hymns", comment: "Display name of 'Cebuano hymns'. Usually appears just by itself (i.e. as a title)")
        case .tagalog:
            return NSLocalizedString("Tagalog hymns", comment: "Display name of 'Tagalog hymns'. Usually appears just by itself (i.e. as a title)")
        case .french:
            return NSLocalizedString("French hymns", comment: "Display name of 'French hymns'. Usually appears just by itself (i.e. as a title)")
        case .spanish:
            return NSLocalizedString("Spanish hymns", comment: "Display name of 'Spanish hymns'. Usually appears just by itself (i.e. as a title)")
        case .korean:
            return NSLocalizedString("Korean hymns", comment: "Display name of 'Korean hymns'. Usually appears just by itself (i.e. as a title)")
        case .japanese:
            return NSLocalizedString("Japanese hymns", comment: "Display name of 'Japanese hymns'. Usually appears just by itself (i.e. as a title)")
        }
    }
}

extension HymnType: CustomStringConvertible {
    var description: String { abbreviatedValue }
}

extension HymnType: Decodable {

    enum HymnTypeCodingError: Error {
        case decoding(String)
    }

    // Decoding an enum: https://stackoverflow.com/a/48204890/1907538
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        guard let hymnType = HymnType.fromAbbreviatedValue(value) else {
            throw HymnTypeCodingError.decoding("Unrecognized abbreviated hymn type: \(value)")
        }
        self = hymnType
    }
}
