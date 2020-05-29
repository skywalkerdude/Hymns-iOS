import SwiftUI

struct CategoryView: View {

    @State fileprivate var isExpanded = false

    let viewModel: CategoryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category)
            if isExpanded {
                List {
                    ForEach(viewModel.subcategories, id: \.self) { subcategory in
                        Text(subcategory)
                    }
                }
            }
        }.onTapGesture {
            self.isExpanded.toggle()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {

    static var previews: some View {

        let viewModel = CategoryViewModel(category: "Category",
                                          subcategories: ["Subcategory 1", "Subcategory 2"])

        return Group {
            CategoryView(viewModel: viewModel).previewLayout(.sizeThatFits)
        }
    }
}
