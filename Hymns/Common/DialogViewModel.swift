import Foundation
import SwiftUI

class DialogViewModel<Content: View>: ObservableObject {

    let contentBuilder: (() -> Content)
    let completion: (() -> Void)?

    init(contentBuilder: @escaping (() -> Content), completion: (() -> Void)? = nil) {
        self.contentBuilder = contentBuilder
        self.completion = completion
    }
}
