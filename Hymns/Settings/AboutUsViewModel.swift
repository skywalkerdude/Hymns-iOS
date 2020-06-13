import Foundation
import SwiftUI

class AboutUsViewModel: BaseSettingViewModel {

    let id = UUID()
    let view: AnyView

    init() {
        view = AbousUsButtonView().eraseToAnyView()
    }
}
