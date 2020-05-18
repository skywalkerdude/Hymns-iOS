import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var queryParamsString: String? {
        guard !self.isEmpty else {
            return nil
        }
        var str = "?"
        for (index, (key, value)) in self.enumerated() {
            if index > 0 {
                str += "&"
            }
            str += "\(key)=\(value)"
        }
        return str
    }
}
