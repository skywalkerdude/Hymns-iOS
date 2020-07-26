import Foundation

extension String {

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

    var toEncodedUrl: URL? {
        guard let urlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: urlString)
    }
}
