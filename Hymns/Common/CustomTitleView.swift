import SwiftUI

struct CustomTitle: View {
    var title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        HStack {
            Text(self.title).customTitleLayout()
            Spacer()
        }
    }
}

struct CustomTitle_Previews: PreviewProvider {
    static var previews: some View {
        CustomTitle(title: "Fav")
    }
}
