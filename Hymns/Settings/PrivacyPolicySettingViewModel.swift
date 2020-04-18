import Foundation
import SwiftUI

class PrivacyPolicySettingViewModel: BaseSettingViewModel {

    let id = UUID()
    let view: AnyView

    init() {
        view = PrivacyPolicySettingView().eraseToAnyView()
    }
}
