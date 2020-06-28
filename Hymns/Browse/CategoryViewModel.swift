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
