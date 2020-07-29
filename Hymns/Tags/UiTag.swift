import Foundation

struct UiTag {

    let title: String
    let color: TagColor

    init(title: String, color: TagColor) {
        self.title = title
        self.color = color
    }
}

extension UiTag: Hashable {
    static func == (lhs: UiTag, rhs: UiTag) -> Bool {
        lhs.title == rhs.title && lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(color)
    }
}

extension UiTag: Identifiable {
    var id: String {
        "\(title):\(color.rawValue)"
    }
}

//import Foundation

struct UiTagC {

    let title: String
    let color: TagColor
    let selected: Bool

    init(title: String, color: TagColor) {
        self.title = title
        self.color = color
        self.selected = false
    }
}

extension UiTagC: Hashable {
    static func == (lhs: UiTagC, rhs: UiTagC) -> Bool {
        lhs.title == rhs.title && lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(color)
    }
}

extension UiTagC: Identifiable {
    var id: String {
        "\(title):\(color.rawValue)"
    }
}
