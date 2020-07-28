import Combine
import Foundation
import SwiftUI

/**
 * Wrapper class for managing `UserDefaults`
 */
class UserDefaultsManager {

    let fontSizeSubject: CurrentValueSubject<FontSize, Never>

    var fontSize: FontSize {
        willSet {
            fontSizeSubject.send(newValue)
            UserDefaults.standard.set(newValue.rawValue, forKey: "fontSize")
        }
    }

    @UserDefault("show_splash_animation", defaultValue: true) var showSplashAnimation: Bool

    init() {
        let initialFontSize = FontSize(rawValue: UserDefaults.standard.string(forKey: "fontSize") ?? FontSize.normal.rawValue) ?? .normal
        self.fontSize = initialFontSize
        self.fontSizeSubject = CurrentValueSubject<FontSize, Never>(initialFontSize)
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/**
 * Possible font sizes for the song lyrics.
 */
public enum FontSize: String {
    case normal = "Normal"
    case large = "Large"
    case xlarge = "Extra Large"

    /**
     * SwiftUI font corresponding to the `FontSize`.
     */
    var font: Font {
        switch self {
        case .normal:
            return .subheadline
        case .large:
            return .body
        case .xlarge:
            return .title
        }
    }

    /**
     * SwiftUI font corresponding to the `FontSize`.
     */
    var minWidth: CGFloat {
        switch self {
        case .normal:
            return 10
        case .large:
            return 12
        case .xlarge:
            return 30
        }
    }
}
