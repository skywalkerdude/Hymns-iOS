import SwiftUI

struct CommentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true

    var searchTitle: URL?

    var body: some View {
        Group<AnyView> {
            guard let url =
                searchTitle else {
                    return ErrorView().eraseToAnyView()
            }
            return NavigationView {
                ZStack {
                    ActivityIndicator().maxSize().opacity(isLoading ? 1 : 0)
                    CommentWebView(isLoading: self.$isLoading, url: url).opacity(isLoading ? 0 : 1)       .navigationBarTitle(Text("Comments"), displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            print("Dismissing sheet view...")
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Done").bold()
                        }))
                }
            }.eraseToAnyView()
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(searchTitle: URL(string: "https://www.hymnal.net/en/hymn/h/1019"))
    }
}
