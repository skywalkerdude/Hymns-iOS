import Foundation

struct HymnalNet {
    private static let scheme = "http"
    private static let host = "www.hymnal.net"
}

extension HymnalNet {
    static func url(path: String) -> URL? {
        guard !path.isEmpty, var components = URLComponents(string: path) else {
            return nil
        }
        components.scheme = Self.scheme
        components.host = Self.host
        return components.url
    }
}
