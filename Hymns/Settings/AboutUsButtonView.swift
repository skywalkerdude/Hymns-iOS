import SwiftUI

struct AbousUsButtonView: View {
    @State var isShowingInfo = false

    var body: some View {
        Button(action: {
            self.isShowingInfo.toggle()
        }, label: {
            Text("About Us").font(.callout)
        }).padding().foregroundColor(.primary)
            .sheet(isPresented: $isShowingInfo) {
                AboutUsInfoView()
        }
    }
}

struct AbousUsView_Previews: PreviewProvider {
    static var previews: some View {
        AbousUsButtonView()
    }
}
