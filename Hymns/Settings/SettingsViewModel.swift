import FirebaseCrashlytics
import Foundation
import MessageUI
import Resolver
import SwiftUI
import UIKit

class SettingsViewModel: ObservableObject {

    let historyStore: HistoryStore = Resolver.resolve()

    @Published var settings: [SettingsModel]? = [SettingsModel]()

    func populateSettings(result: Binding<Result<SettingsToastItem, Error>?>) {
        let repeatChorusViewModel = RepeatChorusViewModel()
        let clearHistoryViewModel = SimpleSettingViewModel(title: NSLocalizedString("Clear recent songs", comment: ""), action: {
            do {
                try self.historyStore.clearHistory()
                result.wrappedValue = .success(.clearHistory)
            } catch let error {
                result.wrappedValue = .failure(error)
            }
        })
        let buyCoffeeViewModel = SimpleSettingViewModel(title: NSLocalizedString("Buy us a coffee!", comment: ""),
                                                        action: {
                                                            guard let url = URL(string: "https://www.buymeacoffee.com/hymnsmobile") else {
                                                                Crashlytics.crashlytics().log("Buy coffee url: 'https://www.buymeacoffee.com/hymnsmobile'")
                                                                Crashlytics.crashlytics().record(error: NonFatal(localizedDescription: "Buy coffee url malformed"))
                                                                result.wrappedValue = .failure(NonFatal(localizedDescription: "Unable to open buy coffee url"))
                                                                return
                                                            }
                                                            UIApplication.shared.open(url)
                                                        })

        #if DEBUG
        settings = [.repeatChorus(repeatChorusViewModel), .clearHistory(clearHistoryViewModel), .aboutUs, .feedback(result), .privacyPolicy,
                    .buyCoffee(buyCoffeeViewModel), .clearUserDefaults]
        #else
        settings = [.repeatChorus(RepeatChorusViewModel()), .clearHistory(clearHistoryViewModel), .aboutUs, .feedback(result), .privacyPolicy,
                    .buyCoffee(buyCoffeeViewModel)]
        #endif
    }
}

enum SettingsModel {
    case repeatChorus(RepeatChorusViewModel)
    case clearHistory(SimpleSettingViewModel)
    case aboutUs
    case feedback(Binding<Result<SettingsToastItem, Error>?>)
    case privacyPolicy
    case clearUserDefaults
    case buyCoffee(SimpleSettingViewModel)
}

extension SettingsModel {

    var view: some View {
        switch self {
        case .repeatChorus(let viewModel):
            return RepeatChorusView(viewModel: viewModel).eraseToAnyView()
        case .clearHistory(let viewModel):
            return SimpleSettingView(viewModel: viewModel).eraseToAnyView()
        case .aboutUs:
            return AboutUsButtonView().eraseToAnyView()
        case .feedback(let result):
            return FeedbackView(result: result).eraseToAnyView()
        case .privacyPolicy:
            return PrivacyPolicySettingView().eraseToAnyView()
        case .clearUserDefaults:
            return ClearUserDefaultsView().eraseToAnyView()
        case .buyCoffee(let viewModel):
            return SimpleSettingView(viewModel: viewModel).eraseToAnyView()
        }
    }
}

extension SettingsModel: Identifiable {
    var id: Int {
        switch self {
        case .repeatChorus:
            return 0
        case .clearHistory:
            return 1
        case .aboutUs:
            return 2
        case .feedback:
            return 3
        case .privacyPolicy:
            return 4
        case .clearUserDefaults:
            return 5
        case .buyCoffee:
            return 6
        }
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
