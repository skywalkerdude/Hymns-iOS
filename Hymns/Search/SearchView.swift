import Resolver
import SwiftUI

struct SearchView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
            VStack {
                HStack {
                    SearchBar(text: $viewModel.searchInput, selectedOnAppear: true)
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel").accentColor(.accentColor)
                    }).padding(.trailing)
                }
                List {
                    ForEach(self.viewModel.songResults) { songResult in
                        NavigationLink(destination: songResult.destinationView) {
                            SongResultView(viewModel: songResult)
                        }
                    }
                }.padding(.trailing, -32.0) // Removes the carat on the right
            }.navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
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
