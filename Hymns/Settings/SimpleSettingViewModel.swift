import Foundation
import SwiftUI

class SimpleSettingViewModel: Identifiable {
    let title: String
    let subtitle: String?
    let action: () -> Void

    init(title: String, subtitle: String?, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    convenience init(title: String, action: @escaping () -> Void) {
        self.init(title: title, subtitle: nil, action: action)
    }
}
