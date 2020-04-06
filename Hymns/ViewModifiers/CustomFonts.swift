import SwiftUI

//Necessary to ensure that our custom fonts are dynamic. Without a view modifier we can still put in a custom font but it will not be dynamic with the users system

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    
    var name: String
    var style: UIFont.TextStyle
    var weight: Font.Weight = .regular
    
    func body(content: Content) -> some View {
        return content.font(Font.custom(
            name,
            size: UIFont.preferredFont(forTextStyle: style).pointSize)
            .weight(weight))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func customFont(
        name: String,
        style: UIFont.TextStyle,
        weight: Font.Weight = .regular) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
}

//default body style
extension View {
    func customBody() -> some View {
        customFont(name: "Montserrat-Regular", style: .body, weight: .regular)
        
    }
}

