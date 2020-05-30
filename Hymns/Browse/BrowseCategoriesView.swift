import SwiftUI

struct BrowseCategoriesView: View {

    let viewModel: BrowseCategoriesViewModel

    var body: some View {
        List(viewModel.categories) { category in
            CategoryView(viewModel: category)
        }.onAppear {
            self.viewModel.fetchCategories()
        }
    }
}

struct BrowseCategoriesView_Previews: PreviewProvider {
    static var previews: some View {

        let viewModel = BrowseCategoriesViewModel(hymnType: nil)
        viewModel.categories = [CategoryViewModel(category: "Category 1", subcategories: ["Subcategory 1", "Subcategory 2"]),
                                CategoryViewModel(category: "Category 2", subcategories: ["Subcategory 2", "Subcategory 3"])]

        return Group {
            BrowseCategoriesView(viewModel: viewModel)
        }
    }
}
