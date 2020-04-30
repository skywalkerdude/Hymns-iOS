import Foundation
import RealmSwift

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

    init(_ entity: HymnIdentifierEntity) {
        self.hymnType = entity.hymnType
        self.hymnNumber = entity.hymnNumber
        self.queryParams = entity.queryParams?.dictionary as? [String: String]
    }
}

extension HymnIdentifier {

    /**
     * - Returns: whether or not the particular hymn is part of a continuous sequence of hymns
     */
    var isContinuous: Bool {
        return hymnType.maxNumber > 0 && hymnNumber.isPositiveInteger && Int(hymnNumber).map { $0 <= hymnType.maxNumber} ?? false
    }
}

class HymnIdentifierEntity: Object {
    // https://stackoverflow.com/questions/29123245/using-enum-as-property-of-realm-model
    @objc dynamic private var hymnTypeRaw = HymnType.classic.rawValue
    var hymnType: HymnType {
        get {
            return HymnType(rawValue: hymnTypeRaw)!
        }
        set {
            hymnTypeRaw = newValue.rawValue
        }
    }
    @objc dynamic var hymnNumber: String = ""
    @objc dynamic var queryParams: String?

    required init() {
        super.init()
    }

    init(_ hymnIdentifier: HymnIdentifier) {
        super.init()
        self.hymnType = hymnIdentifier.hymnType
        self.hymnNumber = hymnIdentifier.hymnNumber
        if let queryParams = hymnIdentifier.queryParams {
            self.queryParams = queryParams.jsonString
        }
    }

    override func isEqual(_ object: Any?) -> Bool {
        return hymnType == (object as? HymnIdentifierEntity)?.hymnType && hymnNumber == (object as? HymnIdentifierEntity)?.hymnNumber && queryParams == (object as? HymnIdentifierEntity)?.queryParams
    }
}
