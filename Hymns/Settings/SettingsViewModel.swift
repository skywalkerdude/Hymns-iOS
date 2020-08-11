import Foundation
import MessageUI
import Resolver
import SwiftUI
import UIKit

class SettingsViewModel: ObservableObject {

    @Published var settings: [AnySettingViewModel]? = [AnySettingViewModel]()

    func populateSettings(result: Binding<Result<MFMailComposeResult, Error>?>) {
        let privacyPolicy = PrivacyPolicySettingViewModel().eraseToAnySettingViewModel()
        let feedback = FeedbackViewModel(result: result).eraseToAnySettingViewModel()
        let aboutUs = AboutUsViewModel().eraseToAnySettingViewModel()

        #if DEBUG
        let clearUserDefaults = ClearUserDefaultsViewModel().eraseToAnySettingViewModel()
        settings = [privacyPolicy, feedback, aboutUs, clearUserDefaults]
        #else
        settings = [privacyPolicy, feedback, aboutUs]
        #endif
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
