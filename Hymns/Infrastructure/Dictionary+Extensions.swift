import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {

    /**
     * Tries to convert the dictionary into a `String`
     */
    var jsonString: String? {
        guard let dict = (self as AnyObject) as? [String: AnyObject] else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
