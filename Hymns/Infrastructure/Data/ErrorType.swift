import SwiftUI
import Foundation

enum ErrorType: Error, Equatable {
    case parsing(description: String)
    case data(description: String)
}

extension ErrorType: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .parsing:
            return NSLocalizedString("Error occurred when parsing a data response", comment: "Error occurred when parsing a data response")
        case .data:
            return NSLocalizedString("Error occurred when making a data request", comment: "Error ocurred when making a data request")
        }
    }
}
