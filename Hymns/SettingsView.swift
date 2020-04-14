import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            CustomTitle(title: "Settings")
            Spacer()
            Text("TODO: Settings")
            Spacer()
        }.navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
