import SwiftUI

struct BrowseView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("TODO: Browse").customBody()
            }.navigationBarTitle("Browse")
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
