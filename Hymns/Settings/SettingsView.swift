import Resolver
import SwiftUI

struct SettingsView: View {
    @State var showingDetail = false
    private let viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Privacy Policy WebKit").accentColor(Color.black).padding(20)
            }.sheet(isPresented: $showingDetail) {
                PrivacyPolicy()
            }
            List {
                ForEach(viewModel.settings) { setting in
                    setting.view
                }
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")

            SettingsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")

            SettingsView()
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
        }
    }
}
