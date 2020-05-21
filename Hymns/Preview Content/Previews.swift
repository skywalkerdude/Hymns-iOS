import SwiftUI

// https://www.avanderlee.com/swiftui/previews-different-states/
struct UIElementPreview<Value: View>: View {

    private let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]

    /// Filter out "base" to prevent a duplicate preview.
    private let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    private let viewToPreview: Value
    private let previewDisplayName: String

    init(_ viewToPreview: Value, previewDisplayName: String) {
        self.viewToPreview = viewToPreview
        self.previewDisplayName = previewDisplayName
    }

    var body: some View {
        Group {
            self.viewToPreview
                .previewLayout(.sizeThatFits)
                .previewDisplayName(previewDisplayName)

            self.viewToPreview
                .previewLayout(.sizeThatFits)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")

            ForEach(localizations, id: \.identifier) { locale in
                self.viewToPreview
                    .previewLayout(.sizeThatFits)
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }

            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                self.viewToPreview
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName("\(sizeCategory)")
            }
        }
    }
}

public extension View {

    func toPreviews(_ previewDisplayName: String = "Default preview") -> some View {
        UIElementPreview(self, previewDisplayName: previewDisplayName)
    }
}
