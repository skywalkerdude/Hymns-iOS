import FirebaseAnalytics
import MessageUI
import Resolver
import SwiftUI

struct SettingsView: View {

    @ObservedObject private var viewModel: SettingsViewModel

    @State var result: Result<MFMailComposeResult, Error>?

    init(viewModel: SettingsViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group { () -> AnyView in
            guard let settings = viewModel.settings else {
                return ErrorView().maxSize().eraseToAnyView()
            }

            guard !settings.isEmpty else {
                return ActivityIndicator().maxSize().eraseToAnyView()
            }

            return
                VStack(alignment: .leading) {
                    CustomTitle(title: "Settings")
                    List {
                        ForEach(settings) { setting in
                            setting.view
                        }
                    }
            }.eraseToAnyView()
        }.onAppear {
            self.viewModel.populateSettings(result: self.$result)
            Analytics.setScreenName("SettingsView", screenClass: "SettingsViewModel")
        }.toast(item: $result, options: ToastOptions(alignment: .center, disappearAfter: 2)) { result -> Text in
            switch result {
            case .success(let success):
                switch success {
                case .sent:
                    return Text("Feedback sent!")
                case .saved:
                    return Text("Feedback not sent but was saved to drafts")
                case .cancelled:
                    return Text("Feedback not sent")
                case .failed:
                    return Text("Feedback failed to send")
                @unknown default:
                    return Text("Feedback failed to send")
                }
            case .failure:
                return Text("Email failed to send")
            }
        }
    }
}

#if DEBUG
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
#endif
