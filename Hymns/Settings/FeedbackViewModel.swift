import Foundation
import MessageUI
import SwiftUI

class FeedbackViewModel: BaseSettingViewModel {

    let id = UUID()
    let view: AnyView

    @Binding var result: Result<MFMailComposeResult, Error>?

    init(result: Binding<Result<MFMailComposeResult, Error>?>) {
        self._result = result
        view = FeedbackView(result: result).eraseToAnyView()
    }
}
