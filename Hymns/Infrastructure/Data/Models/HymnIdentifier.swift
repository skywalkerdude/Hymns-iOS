import Foundation

/**
 * Uniquely identifies a hymn.
 */
struct HymnIdentifier: Hashable {
    let hymnType: HymnType
    let hymnNumber: String
    let queryParams: [String: String]?
    
    init(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.queryParams = queryParams
    }
    
    init(hymnType: HymnType, hymnNumber: String) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.queryParams = nil
    }
}
