import Foundation
import SwiftUI

public struct DialogOptions {

    let dimBackground: Bool

    init(dimBackground: Bool = true) {
        self.dimBackground = dimBackground
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
