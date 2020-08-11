import FirebaseCrashlytics
import SwiftUI

struct PrivacyPolicySettingView: View {

    @State private var showPrivacyPolicy = false

    var body: some View {
        Button(action: {self.showPrivacyPolicy.toggle()}, label: {
            Text("Privacy policy").font(.callout)
        }).padding().foregroundColor(.primary)
            .sheet(isPresented: self.$showPrivacyPolicy, content: { () -> AnyView in
                guard let url = URL(string: "https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac") else {
                    Crashlytics.crashlytics().log("Privacy policy url: 'https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac'")
                    Crashlytics.crashlytics().record(error: NonFatal(localizedDescription: "Privacy policy url malformed"))
                    return ErrorView().eraseToAnyView()
                }
                return HStack {
                    Button(action: {
                        self.showPrivacyPolicy = false
                    }, label: {
                        Text("Close")
                    })
                    WebView(url: url)
                }.eraseToAnyView()
            })
    }
}

#if DEBUG
struct PrivacyPolicySettingView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicySettingView().toPreviews()
    }
}
#endif
