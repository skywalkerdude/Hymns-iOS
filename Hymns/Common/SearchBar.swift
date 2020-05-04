import SwiftUI

/**
 * Custom search bar that will animate in a `Cancel` button when activated/selected.
 * https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui
 */
struct SearchBar: View {

    @Binding var searchText: String
    @Binding var searchActive: Bool
    let placeholderText: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").padding(.leading, 6)
                TextField(placeholderText, text: $searchText)
                if !self.searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
            }.onTapGesture {
                if !self.searchActive {
                    withAnimation {
                        self.searchActive = true
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(Color("darkModeSearchSymbol"))
            .background(Color("darkModeSearchBackgrouund"))
            .cornerRadius(CGFloat(integerLiteral: 10))

            if searchActive {
                Button("Cancel") {
                    // this must be placed before the other commands here
                    UIApplication.shared.endEditing(true)
                    if !self.searchText.isEmpty {
                        self.searchText = ""
                    }
                    withAnimation {
                        self.searchActive = false
                    }
                }
                .foregroundColor(Color(.systemBlue))
                .transition(AnyTransition.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.2))
            }
        }
    }
}

#if DEBUG
struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderText = "Search by numbers or words"
        var emptySearchText = ""
        let emptySearchTextBinding = Binding<String>(
            get: {emptySearchText},
            set: {emptySearchText = $0})
        var searchInactive = false
        let searchInactiveBinding = Binding<Bool>(
            get: {searchInactive},
            set: {searchInactive = $0})
        let searchInactiveBar = SearchBar(searchText: emptySearchTextBinding, searchActive: searchInactiveBinding, placeholderText: placeholderText)
        var searchActive = true
        let searchActiveBinding = Binding<Bool>(
            get: {searchActive},
            set: {searchActive = $0})
        let searchActiveBar = SearchBar(searchText: emptySearchTextBinding, searchActive: searchActiveBinding, placeholderText: placeholderText)
        var searchText = "Who let the dogs out?"
        let searchTextBinding = Binding<String>(
            get: {searchText},
            set: {searchText = $0})
        let searchTextBar = SearchBar(searchText: searchTextBinding, searchActive: searchActiveBinding, placeholderText: placeholderText)
        return
            Group {
                searchInactiveBar.previewDisplayName("inactive")
                searchActiveBar.previewDisplayName("active")
                searchTextBar.previewDisplayName("with search text")
            }.previewLayout(.sizeThatFits)
    }
}
#endif
