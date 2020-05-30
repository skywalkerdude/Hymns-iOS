import SwiftUI

struct CategoryView: View {

    @State fileprivate var isExpanded = false

    let viewModel: CategoryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category).onTapGesture {
                self.isExpanded.toggle()
            }
            if isExpanded {
                List {
                    ForEach(viewModel.subcategories, id: \.self) { subcategory in
                        NavigationLink(destination: Text(subcategory)) {
                            Text("TOOD create results")
                        }
                    }
                }.frame(height: CGFloat(viewModel.subcategories.count * 45))
            }
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
