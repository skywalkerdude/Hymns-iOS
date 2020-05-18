import Foundation
import RealmSwift

/**
 * Uniquely identifies a hymn.
 */
struct HymnIdentifier: Hashable, Equatable {
    let hymnType: HymnType
    let hymnNumber: String
    let queryParams: [String: String]?
    var queryParamString: String {
        guard let queryParams = queryParams else {
            return ""
        }
        return queryParams.queryParamsString ?? ""
    }
}

/**
 * Class wrapper for HymnIdentifiers so it can be used as an ObjectIdentifier.
 * https://developer.apple.com/documentation/swift/objectidentifier/1538294-init
 */
class HymnIdentifierRef {
    let identifier: HymnIdentifier
    init(_ identifier: HymnIdentifier) {
        self.identifier = identifier
    }
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
    func toObjectIdentifier() -> ObjectIdentifier {
        ObjectIdentifier(HymnIdentifierRef(self))
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
        self.queryParams = hymnIdentifier.queryParamString
    }

    override func isEqual(_ object: Any?) -> Bool {
        return hymnType == (object as? HymnIdentifierEntity)?.hymnType && hymnNumber == (object as? HymnIdentifierEntity)?.hymnNumber && queryParams == (object as? HymnIdentifierEntity)?.queryParams
    }

    override var hash: Int {
        return hymnType.abbreviatedValue.hash + hymnNumber.hash + (queryParams?.hash ?? 0)
    }
}
