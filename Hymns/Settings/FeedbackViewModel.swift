import Foundation
import SwiftUI

class FeedbackViewModel: BaseSettingViewModel {

    let id = UUID()
    let view: AnyView

    init() {
        view = FeedbackView().eraseToAnyView()
    }
}
