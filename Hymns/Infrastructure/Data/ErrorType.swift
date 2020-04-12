import SwiftUI
import Foundation

enum ErrorType: Error, Equatable {
    case parsing(description: String)
    case network(description: String)
}

extension ErrorType: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .parsing:
            return NSLocalizedString("Error occurred when parsing a network response", comment: "Error occurred when parsing a network response")
        case .network:
            return NSLocalizedString("Error occurred when making a network request", comment: "Error ocurred when making a network request")
        }
    }
}
