import SwiftUI

struct PrivacyPolicySettingView: View {

    @State private var showPrivacyPolicy = false

    var body: some View {
        Button(action: {self.showPrivacyPolicy.toggle()}, label: {
            Text("Privacy Policy").font(.callout)
        })
        .padding().foregroundColor(.black)
        .sheet(isPresented: self.$showPrivacyPolicy) {
            WebView(url: URL(string: "https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac")!)
        }
    }
}

#if DEBUG
struct PrivacyPolicySettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                Group {
                    PrivacyPolicySettingView()
                }.previewDisplayName("Regular")

                Group {
                    PrivacyPolicySettingView()
                }
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            }
            .previewLayout(.fixed(width: 200, height: 50))

            Group {
                PrivacyPolicySettingView()
            }
            .previewLayout(.fixed(width: 450, height: 150))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Extra Extra Extra Large")
        }
    }
}
#endif
