import SwiftUI

struct TagPill: ViewModifier {

    let backgroundColor: Color
    let foregroundColor: Color
    let showBorder: Bool

    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(foregroundColor, lineWidth: showBorder ? 3 : 0))
    }
}

extension View {
    func tagPill(backgroundColor: Color, foregroundColor: Color, showBorder: Bool = true) -> some View {
        return self.modifier(TagPill(backgroundColor: backgroundColor, foregroundColor: foregroundColor, showBorder: showBorder))
    }
}
