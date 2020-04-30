import Foundation
import SwiftUI

extension View {

    /**
     * Use type erasure as a way to return a generic protocol as a type, instead of forcing a concrete type (https://www.swiftbysundell.com/articles/type-erasure-using-closures-in-swift/).
     */
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }

    /**
     * Syntactic sugar to hide the navigation bar
     */
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }

    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }

    func maxSize(alignment: Alignment = .center) -> some View {
        return self.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

/**
 * Dismiss the keyboard when you drag down.
 * https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui
 */
struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
