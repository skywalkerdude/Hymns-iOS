import Foundation
import MessageUI
import Resolver
import SwiftUI
import UIKit

class SettingsViewModel: ObservableObject {

    let historyStore: HistoryStore = Resolver.resolve()

    @Published var settings: [SettingsModel]? = [SettingsModel]()

    func populateSettings(result: Binding<Result<SettingsToastItem, Error>?>) {
        let clearHistoryViewModel = SimpleSettingViewModel(title: NSLocalizedString("Clear recent songs", comment: ""), action: {
            do {
                try self.historyStore.clearHistory()
                result.wrappedValue = .success(.clearHistory)
            } catch let error {
                result.wrappedValue = .failure(error)
            }
        })

        #if DEBUG
        settings = [.privacyPolicy, .feedback(result), .aboutUs, .clearHistory(clearHistoryViewModel), .clearUserDefaults]
        #else
        settings = [.privacyPolicy, .feedback(result), .aboutUs, .clearHistory(clearHistoryViewModel)]
        #endif
    }
}

enum SettingsModel {
    case privacyPolicy
    case feedback(Binding<Result<SettingsToastItem, Error>?>)
    case aboutUs
    case clearHistory(SimpleSettingViewModel)
    case clearUserDefaults
}

extension SettingsModel {

    var view: some View {
        switch self {
        case .privacyPolicy:
            return PrivacyPolicySettingView().eraseToAnyView()
        case .feedback(let result):
            return FeedbackView(result: result).eraseToAnyView()
        case .aboutUs:
            return AboutUsButtonView().eraseToAnyView()
        case .clearHistory(let viewModel):
            return SimpleSettingView(viewModel: viewModel).eraseToAnyView()
        case .clearUserDefaults:
            return ClearUserDefaultsView().eraseToAnyView()
        }
    }
}

extension SettingsModel: Identifiable {
    var id: Int {
        switch self {
        case .privacyPolicy:
            return 0
        case .feedback:
            return 1
        case .aboutUs:
            return 2
        case .clearHistory:
            return 3
        case .clearUserDefaults:
            return 4
        }
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
