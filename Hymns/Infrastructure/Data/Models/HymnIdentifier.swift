import Foundation

/**
 * Uniquely identifies a hymn.
 */
struct HymnIdentifier: Hashable, Equatable {
    let hymnType: HymnType
    let hymnNumber: String
    let queryParams: [String: String]?
}

extension HymnIdentifier {

    // Allows us to use a customer initializer along with the default memberwise one
    // https://www.hackingwithswift.com/articles/106/10-quick-swift-tips
    init(hymnType: HymnType, hymnNumber: String) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.queryParams = nil
    }
}
