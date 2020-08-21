import Foundation

class CategoryViewModel: ObservableObject {

    let category: String
    let hymnType: HymnType?
    var subcategories: [SubcategoryViewModel]

    init(category: String, hymnType: HymnType?, subcategories: [SubcategoryViewModel]) {
        self.category = category
        self.hymnType = hymnType
        self.subcategories = subcategories
    }
}

extension CategoryViewModel: Identifiable {
    var id: String {
        "\(category) \(hymnType?.abbreviatedValue ?? "nil") \(subcategories)"
    }
}

extension CategoryViewModel: Hashable {
    static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        lhs.category == rhs.category && lhs.subcategories == rhs.subcategories && lhs.hymnType == rhs.hymnType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        hasher.combine(hymnType)
        hasher.combine(subcategories)
    }
}

extension CategoryViewModel: CustomStringConvertible {
    var description: String {
        "\(category): \(subcategories) with type \(String(describing: hymnType?.abbreviatedValue))"
    }
}
