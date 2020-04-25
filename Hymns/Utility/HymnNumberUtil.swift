import Foundation

class HymnNumberUtil {

    /**
     * - Returns: An array of numbers as strings that contains the `hymnNumber`.
     */
    static func matchHymnNumbers(hymnNumber: String) -> [String] {
        if hymnNumber.isEmpty {
            return [String]()
        }
        return (1...HymnType.classic.maxNumber).map({String($0)}).filter {$0.contains(hymnNumber)}
    }
}
