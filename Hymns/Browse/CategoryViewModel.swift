import Foundation

class CategoryViewModel: ObservableObject {

    let category: String
    let subcategories: [String]

    init(category: String, subcategories: [String]) {
        self.category = category
        self.subcategories = subcategories
    }
}

extension CategoryViewModel: Identifiable {
}

extension CategoryViewModel: Equatable {
    static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        lhs.category == rhs.category && lhs.subcategories == rhs.subcategories
    }
}

extension CategoryViewModel: CustomStringConvertible {
    var description: String { "\(category): \(subcategories)" }
}
