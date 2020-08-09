import Foundation
import SwiftUI

public struct DialogOptions {

    let dimBackground: Bool
    let transition: AnyTransition?

    init(dimBackground: Bool = true, transition: AnyTransition? = nil) {
        self.dimBackground = dimBackground
        self.transition = transition
    }
}

class DialogViewModel<Content: View>: ObservableObject {

    @Published var opacity: Double = 1

    let contentBuilder: (() -> Content)
    let closeHandler: (() -> Void)?
    let options: DialogOptions

    init(contentBuilder: @escaping (() -> Content), closeHandler: (() -> Void)? = nil,
         options: DialogOptions = DialogOptions()) {
        self.contentBuilder = contentBuilder
        self.closeHandler = closeHandler
        self.options = options
    }
}
