import SwiftUI

extension ContentSizeCategory {

    func isAccessibilityCategory() -> Bool {
        if #available(iOS 13.4, *) {
            return isAccessibilityCategory
        } else {
            let a11ySizes: [ContentSizeCategory] = [.accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge,
                                                    .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge]
            return a11ySizes.contains(self)
        }
    }
}
