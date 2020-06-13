import Foundation
import Resolver
import SwiftUI
import UIKit

struct SettingsViewModel {

    let settings: [AnySettingViewModel]

    init(application: Application = Resolver.resolve()) {
        let privacyPolicy = PrivacyPolicySettingViewModel().eraseToAnySettingViewModel()
        let feedback = FeedbackViewModel().eraseToAnySettingViewModel()
        let aboutUs = AboutUsViewModel().eraseToAnySettingViewModel()
        settings = [privacyPolicy, feedback, aboutUs]
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
