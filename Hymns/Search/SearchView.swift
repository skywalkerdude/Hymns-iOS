import Resolver
import SwiftUI

struct SearchView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("TODO delee searchview and implement in home vieiw instead")
//            VStack {
//                HStack {
//                    SearchBar(text: $viewModel.searchInput, selectedOnAppear: true)
//                }
//                List {
//                    ForEach(self.viewModel.songResults) { songResult in
//                        NavigationLink(destination: songResult.destinationView) {
//                            SongResultView(viewModel: songResult)
//                        }
//                    }
//                }
//                // Removes the carat on the right
//                .padding(.trailing, CGFloat.init(integerLiteral: -32))
//            }.navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            SearchView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            SearchView()
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
        }
    }
}
