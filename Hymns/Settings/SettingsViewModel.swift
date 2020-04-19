import Foundation
import Resolver
import SwiftUI
import UIKit

struct SettingsViewModel {

    let settings: [AnySettingViewModel]

    init(application: Application = Resolver.resolve()) {
        let privacyPolicy = PrivacyPolicySettingViewModel()
        settings = [privacyPolicy.eraseToAnySettingViewModel()]
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
