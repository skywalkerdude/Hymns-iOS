import RealmSwift

class TagEntity: Object, Identifiable {
    @objc dynamic var primaryKey: String!
    @objc dynamic var hymnIdentifierEntity: HymnIdentifierEntity!
    @objc dynamic var songTitle: String!
    @objc dynamic var tag: String!

    //https://stackoverflow.com/questions/29123245/using-enum-as-property-of-realm-model
    @objc private dynamic var privateTagColor: Int = TagColor.none.rawValue
    var color: TagColor {
        get { return TagColor(rawValue: privateTagColor)! }
        set { privateTagColor = newValue.rawValue }
    }

    required init() {
        super.init()
    }

    init(hymnIdentifier: HymnIdentifier, songTitle: String, tag: String, color: TagColor) {
        super.init()
        self.primaryKey = Self.createPrimaryKey(hymnIdentifier: hymnIdentifier, tag: tag, color: color)
        self.hymnIdentifierEntity = HymnIdentifierEntity(hymnIdentifier)
        self.songTitle = songTitle
        self.tag = tag
        self.color = color
    }

    override static func primaryKey() -> String? {
        return "primaryKey"
    }

    static func createPrimaryKey(hymnIdentifier: HymnIdentifier, tag: String, color: TagColor) -> String {
        return ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]()):\(tag):\(color.rawValue)")
    }

    override func isEqual(_ object: Any?) -> Bool {
        return primaryKey == (object as? TagEntity)?.primaryKey
    }

    override var hash: Int {
        return primaryKey.hash
    }
}
