import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Settings").customTitle()
                Spacer()
            }
            Spacer()
            Text("TODO: Settings")
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
