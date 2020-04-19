import Foundation
import SwiftUI

class SimpleSettingViewModel: BaseSettingViewModel {

    let id = UUID()
    let title: String
    let subtitle: String?
    let action: () -> Void
    let view: AnyView

    init(title: String, subtitle: String?, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        view = SimpleSettingView(title: title, subtitle: subtitle, action: action).eraseToAnyView()
    }

    convenience init(title: String, action: @escaping () -> Void) {
        self.init(title: title, subtitle: nil, action: action)
    }
}
