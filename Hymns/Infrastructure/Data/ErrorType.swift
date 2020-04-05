import Foundation

enum ErrorType: Error {
    case parsing(description: String)
    case network(description: String)
}
