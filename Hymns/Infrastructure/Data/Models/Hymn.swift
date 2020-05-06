import Foundation

/**
 * Structure of a Hymn object returned from the network.
 */
struct Hymn: Codable, Equatable {
    let title: String
    let metaData: [MetaDatum]
    let lyrics: [Verse]
}

extension Hymn {
    func getMetaDatum(name: MetaDatumName) -> MetaDatum? {
        let jsonKey = name.jsonKey
        return metaData.first { metaDatum -> Bool in
            if metaDatum.name != jsonKey {
                return false
            }
            // Special case since the json key for both "Music" and "Composer" is just "Music." Therefore we need
            // to do some special logic go differentiate them.
            if name == .music {
                return metaDatum.data.contains { datum -> Bool in
                    let value = datum.value
                    if value == DatumValue.mp3.rawValue || value == DatumValue.midi.rawValue || value == DatumValue.tune.rawValue {
                        return true
                    }
                    return false
                }
            }
            if name == .composer {
                return !metaDatum.data.contains { datum -> Bool in
                    let value = datum.value
                    if value == DatumValue.mp3.rawValue || value == DatumValue.midi.rawValue || value == DatumValue.tune.rawValue {
                        return true
                    }
                    return false
                }
            }
            return true
        }
    }
}
