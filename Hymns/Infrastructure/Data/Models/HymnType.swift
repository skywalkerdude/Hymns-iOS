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
}

extension HymnType: CustomStringConvertible {
    var description: String { abbreviatedValue }
}
