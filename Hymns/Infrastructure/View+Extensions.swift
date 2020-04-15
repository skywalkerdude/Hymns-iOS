import Foundation
import SwiftUI

extension View {

    /**
     * Use type erasure as a way to return a generic protocol as a type, instead of forcing a concrete type (https://www.swiftbysundell.com/articles/type-erasure-using-closures-in-swift/).
     */
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}