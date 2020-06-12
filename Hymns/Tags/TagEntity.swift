import SwiftUI
import RealmSwift

class TagEntity: Object, Identifiable {
    @objc dynamic var primaryKey: String!
    @objc dynamic var hymnIdentifierEntity: HymnIdentifierEntity!
    @objc dynamic var songTitle: String!
    @objc dynamic var tag: String!

    //https://stackoverflow.com/questions/29123245/using-enum-as-property-of-realm-model
    @objc private dynamic var privateTagColor: Int = TagColor.none.rawValue
    var tagColor: TagColor {
        get { return TagColor(rawValue: privateTagColor)! }
        set { privateTagColor = newValue.rawValue }
    }

    required init() {
        super.init()
    }

    init(hymnIdentifier: HymnIdentifier, songTitle: String, tag: String, tagColor: TagColor) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier, tag: tag)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = songTitle
        self.tag = tag
        self.tagColor = tagColor
    }

    override static func primaryKey() -> String? {
        return "primaryKey"
    }

    static func createPrimaryKey(hymnIdentifier: HymnIdentifier, tag: String) -> String {
        return ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]()):\(tag)")
    }

    override func isEqual(_ object: Any?) -> Bool {
        return primaryKey == (object as? TagEntity)?.primaryKey
    }

    override var hash: Int {
        return primaryKey.hash
    }
}

enum TagColor: Int {
    case none, blue, green, yellow, red
}

extension TagColor {
    var background: Color {
        switch self {
        case .none:
            return Color(.systemBackground)
        case .blue:
            return Color(red: 2/255, green: 118/255, blue: 254/255, opacity: 0.2)
        case .green:
            return Color(red: 80/255, green: 227/255, blue: 194/255, opacity: 0.2)
        case .yellow:
            return Color(red: 255/255, green: 209/255, blue: 0/255, opacity: 0.2)
        case .red:
            return Color(red: 255/255, green: 0, blue: 31/255, opacity: 0.2)
        }
    }

    var foreground: Color {
        switch self {
        case .none:
            return Color.primary
        case .blue:
            return Color(red: 2/255, green: 118/255, blue: 254/255, opacity: 1.0)
        case .green:
            return Color(red: 35/255, green: 190/255, blue: 155/255, opacity: 1.0)
        case .yellow:
            return Color(red: 176/255, green: 146/255, blue: 7/255, opacity: 1.0)
        case .red:
            return Color(red: 255/255, green: 0, blue: 31/255, opacity: 0.78)
        }
    }
}
