import Combine
import Foundation
import Resolver

protocol HymnalNetService {
    func getData(_ url: URL) -> AnyPublisher<Data, ErrorType>
}

class HymnalNetServiceImpl: HymnalNetService {
    private let session: URLSession

    init(session: URLSession = Resolver.resolve()) {
        self.session = session
    }

    func getData(_ url: URL) -> AnyPublisher<Data, ErrorType> {
        session.dataTaskPublisher(for: URLRequest(url: url))
            .map({ (data: Data, _: URLResponse) -> Data in
                data
            }).mapError({ failure -> ErrorType in
                .data(description: failure.localizedDescription)
            }).eraseToAnyPublisher()
    }
}

extension Resolver {
    static func registerHymnalNetService() {
        register {HymnalNetServiceImpl() as HymnalNetService}.scope(application)
    }
}

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
