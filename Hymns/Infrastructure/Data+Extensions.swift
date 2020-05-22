import Foundation

extension Data {

    /**
     * Tries to convert the `Data` into a `String`
     */
    var toString: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}

// https://stackoverflow.com/questions/38023838/round-trip-swift-number-types-to-from-data/38024025#38024025
extension Data {

    init<T>(fromArray values: [T]) {
        self = values.withUnsafeBytes { Data($0) }
    }

    func toArray<T>(type: T.Type) -> [T] where T: ExpressibleByIntegerLiteral {
        var array = [T](repeating: 0, count: self.count/MemoryLayout<T>.stride)
        _ = array.withUnsafeMutableBytes { copyBytes(to: $0) }
        return array
    }
}
