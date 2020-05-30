import SwiftUI

struct BrowseCategoriesView: View {

    @ObservedObject var viewModel: BrowseCategoriesViewModel

    var body: some View {
        Group<AnyView> {
            guard let categories = viewModel.categories else {
                return Text("error!").maxSize().eraseToAnyView()
            }

            guard !categories.isEmpty else {
                return ActivityIndicator().maxSize().onAppear {
                    self.viewModel.fetchCategories()
                }.eraseToAnyView()
            }

            return List(categories) { category in
                CategoryView(viewModel: category)
            }.eraseToAnyView()
        }.background(Color(.systemBackground))
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
