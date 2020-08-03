import SwiftUI
import Foundation

/**
 * Non-fatal error that shouldn't crash the app, but also shouldn't ever happen in the wild.
 */
struct NonFatal: Error, Equatable {
    let localizedDescription: String
}
