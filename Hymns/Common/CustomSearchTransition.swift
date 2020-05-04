import SwiftUI

extension AnyTransition {
    static var customSearchTransition: AnyTransition {
        let insertion = AnyTransition.opacity
        let removal = AnyTransition.move(edge: .trailing)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
