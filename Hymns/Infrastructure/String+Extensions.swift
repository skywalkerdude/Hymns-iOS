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

    /**
     * - Returns: whether or not the string is an integer
     */
    var isPositiveInteger: Bool {
        return !isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /**
     * - Returns: string with leading whitespace and new lines trimmed out.
     */
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
