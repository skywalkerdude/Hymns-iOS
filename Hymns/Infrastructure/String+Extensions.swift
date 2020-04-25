import Foundation

extension String {

    /**
     * Tries to convert the string into a `dictionary`
     */
    var dictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
