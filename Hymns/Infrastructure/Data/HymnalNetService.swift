import Foundation

struct HymnalNet {
    private static let scheme = "http"
    private static let host = "www.hymnal.net"
}

extension HymnalNet {
    static func url(path: String) -> URL? {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        components.path = path
        return components.url
    }
}
