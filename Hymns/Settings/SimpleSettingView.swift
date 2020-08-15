import SwiftUI

struct SimpleSettingView: View {

    let title: String
    let subtitle: String?
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.callout)
                subtitle.map { Text($0).font(.caption) }
            }
        }).padding().foregroundColor(.primary)
    }
}

extension SimpleSettingView {

    // Allows us to use a customer initializer along with the default memberwise one
    // https://www.hackingwithswift.com/articles/106/10-quick-swift-tips
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = nil
        self.action = action
    }
}

#if DEBUG
struct SimpleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                Group {
                    SimpleSettingView(title: "Theme", subtitle: "Using system theme", action: {})
                    SimpleSettingView(title: "Privacy policy", action: {})
                }.previewDisplayName("Regular")

                Group {
                    SimpleSettingView(title: "Theme", subtitle: "Using system theme", action: {})
                    SimpleSettingView(title: "Privacy policy", action: {})
                }
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            }
            .previewLayout(.fixed(width: 200, height: 50))

            Group {
                SimpleSettingView(title: "Theme", subtitle: "Using system theme", action: {})
                SimpleSettingView(title: "Privacy policy", action: {})
            }
            .previewLayout(.fixed(width: 450, height: 150))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Extra Extra Extra Large")
        }
    }
}
#endif
