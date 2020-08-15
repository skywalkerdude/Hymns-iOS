import Foundation
import MessageUI
import SwiftUI

class FeedbackViewModel: BaseSettingViewModel {

    let id = UUID()
    let view: AnyView

    init(result: Binding<Result<SettingsToastItem, Error>?>) {
        view = FeedbackView(result: result).eraseToAnyView()
    }
}
