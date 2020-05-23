import Foundation
import SwiftUI

/**
 * Wrapper class for managing `UserDefaults`
 */
class UserDefaulstManager {

    var fontSize: FontSize = FontSize(rawValue: UserDefaults.standard.string(forKey: "fontSize") ?? "Normal") ?? .normal {
        willSet {
            UserDefaults.standard.set(newValue.rawValue, forKey: "fontSize")
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
            return .callout
        case .large:
            return .body
        case .xlarge:
            return .subheadline
        }
    }
}
