import SwiftUI
import Foundation

enum ErrorType: Error, Equatable {
    case parsing(description: String)
    case data(description: String)
}

extension ErrorType: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .parsing(let description):
            return description
        case .data(let description):
            return description
        }
    }
}
