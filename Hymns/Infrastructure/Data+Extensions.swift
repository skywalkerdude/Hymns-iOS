import Foundation

extension Data {

    /**
     * Tries to convert the `Data` into a `String`
     */
    var toString: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
