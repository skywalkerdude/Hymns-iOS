import Foundation
import MessageUI
import Resolver
import SwiftUI
import UIKit

class SettingsViewModel: ObservableObject {

    let historyStore: HistoryStore = Resolver.resolve()

    @Published var settings: [AnySettingViewModel]? = [AnySettingViewModel]()

    func populateSettings(result: Binding<Result<SettingsToastItem, Error>?>) {
        let privacyPolicy = PrivacyPolicySettingViewModel().eraseToAnySettingViewModel()
        let feedback = FeedbackViewModel(result: result).eraseToAnySettingViewModel()
        let aboutUs = AboutUsViewModel().eraseToAnySettingViewModel()

        let clearHistory = SimpleSettingViewModel(title: NSLocalizedString("Clear recent songs", comment: ""), action: {
            do {
                try self.historyStore.clearHistory()
                result.wrappedValue = .success(.clearHistory)
            } catch let error {
                result.wrappedValue = .failure(error)
            }
        }).eraseToAnySettingViewModel()

        #if DEBUG
        let clearUserDefaults = ClearUserDefaultsViewModel().eraseToAnySettingViewModel()
        settings = [privacyPolicy, feedback, aboutUs, clearHistory, clearUserDefaults]
        #else
        settings = [privacyPolicy, feedback, aboutUs, clearHistory]
        #endif
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
