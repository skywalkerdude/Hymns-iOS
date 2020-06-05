import Foundation
import SwiftUI

struct SubcategoryViewModel: Equatable, Hashable {
    let subcategory: String?
    let count: Int
}

struct SubcategoryView: View {

    let viewModel: SubcategoryViewModel

    var body: some View {
        HStack {
            Text(viewModel.subcategory != nil ? viewModel.subcategory! : "All subcategories")
            Spacer()
            Text("\(viewModel.count)")
        }
    }
}

struct SubcategoryView_Previews: PreviewProvider {

    static var previews: some View {

        let viewModel = SubcategoryViewModel(subcategory: "His Worship", count: 5)

        return Group {
            SubcategoryView(viewModel: viewModel).previewLayout(.sizeThatFits)
        }
    }
}
