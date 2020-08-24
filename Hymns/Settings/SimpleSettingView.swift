import SwiftUI

struct SimpleSettingView: View {

    let viewModel: SimpleSettingViewModel

    var body: some View {
        Button(action: viewModel.action, label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.title).font(.callout)
                viewModel.subtitle.map { Text($0).font(.caption) }
            }
        }).padding().foregroundColor(.primary)
    }
}

#if DEBUG
struct SimpleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let theme = SimpleSettingViewModel(title: "Theme", subtitle: "Using system theme", action: {})
        let privacyPolicy = SimpleSettingViewModel(title: "Privacy policy", action: {})
        return Group {
            Group {
                Group {
                    SimpleSettingView(viewModel: theme)
                    SimpleSettingView(viewModel: privacyPolicy)
                }.previewDisplayName("Regular")

                Group {
                    SimpleSettingView(viewModel: theme)
                    SimpleSettingView(viewModel: privacyPolicy)
                }
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            }
            .previewLayout(.fixed(width: 200, height: 50))

            Group {
                SimpleSettingView(viewModel: theme)
                SimpleSettingView(viewModel: privacyPolicy)
            }
            .previewLayout(.fixed(width: 450, height: 150))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Extra Extra Extra Large")
        }
    }
}
#endif
