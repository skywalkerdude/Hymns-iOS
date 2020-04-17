import Foundation
import Resolver
import SwiftUI
import UIKit

struct SettingsViewModel {

    let settings: [AnySettingViewModel]

    let privacyPolicy: SimpleSettingViewModel

    init(application: Application = Resolver.resolve()) {
        privacyPolicy = SimpleSettingViewModel(title: "Privacy Policy") {
            if let link = URL(string: "https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac") {
                application.open(link)
            }
        }
        settings = [privacyPolicy.eraseToAnySettingViewModel()]
    }
}

extension Resolver {
    public static func registerSettingsViewModel() {
        register {SettingsViewModel()}.scope(graph)
    }
}
