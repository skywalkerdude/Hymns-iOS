import Foundation

/**
 * Represents a single point of data for a hymn.
 */
struct Datum: Codable, Equatable {
    let value: String
    let path: String
}

enum DatumValue: String {
    /**
     * Datum value for sheet music pdf's
     */
    case leadSheet = "Lead Sheet"

    /**
     * Datum value for sheet music svg's
     */
    case svg = "svg"

    /**
     * Hymnal.net calls the chords "text," so we need to look for the "text" key instead of chords
     * when parsing the json
     */
    case text = "Text"

    /**
     * Datum value for the guitar sheet music path.
     */
    case guitar = "Guitar"

    /**
     * Datum value  for the piano sheet music path.
     */
    case piano = "Piano"

    /**
     * Datum value for different languagesJson
     */
    case languages = "Languages"

    /**
     * Datum value for relevantJson songs
     */
    case relevant = "Relevant"

    /**
     * Datum value for media urls
     */
    case musicPaths = "Music"

    /**
     * Datum value for mp3 url
     */
    case mp3 = "mp3"

    /**
     * Datum value for midi url
     */
    case midi = "MIDI"

    /**
     * Datum value for tune(midi) url
     */
    case tune = "Tune (MIDI)"
}
