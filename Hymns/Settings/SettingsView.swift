import Resolver
import SwiftUI

struct SettingsView: View {

    private let viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            CustomTitle(title: "Settings")
            viewModel.privacyPolicy
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
