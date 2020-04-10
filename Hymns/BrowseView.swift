import SwiftUI

struct BrowseView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Browse").customTitle()
                Spacer()
            }
            Spacer()
            Text("TODO: Browse")
            Spacer()
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
