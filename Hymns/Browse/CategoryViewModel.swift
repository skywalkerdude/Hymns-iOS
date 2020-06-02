import Foundation

class CategoryViewModel: ObservableObject {

    let category: String
    let subcategories: [String]
    let hymnType: HymnType?

    init(category: String, subcategories: [String], hymnType: HymnType? = nil) {
        self.category = category
        self.subcategories = subcategories
        self.hymnType = hymnType
    }
}

extension CategoryViewModel: Identifiable {
}

extension CategoryViewModel: Equatable {
    static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        lhs.category == rhs.category && lhs.subcategories == rhs.subcategories && lhs.hymnType == rhs.hymnType
    }
}

extension CategoryViewModel: CustomStringConvertible {
    var description: String {
        "\(category): \(subcategories) with type \(String(describing: hymnType?.abbreviatedValue))"
    }
}
