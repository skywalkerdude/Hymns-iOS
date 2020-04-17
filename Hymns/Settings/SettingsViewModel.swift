import Foundation
import Resolver
import SwiftUI
import UIKit

struct SettingsViewModel {

    let privacyPolicy: SimpleSettingView

    init(application: Application = Resolver.resolve()) {
        privacyPolicy =
            SimpleSettingView(viewModel:
                SimpleSettingViewModel(title: "Privacy Policy") {
                    if let link = URL(string: "https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac") {
                        application.open(link)
                    }
            })
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
