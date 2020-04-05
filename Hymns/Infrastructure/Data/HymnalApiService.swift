import Combine
import Foundation
import Resolver

/**
 * Service to contact the Hymnal API.
 */
protocol HymnalApiService {
    func getHymn(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]?) -> AnyPublisher<Hymn, ErrorType>
}

/**
 * Implementation of HymnalApiService that uses Alamofire.
 */
class HymnalApiServiceImpl: HymnalApiService {

    private let decoder: JSONDecoder
    private let session: URLSession
    
    init(decoder: JSONDecoder, session: URLSession) {
        self.decoder = decoder
        self.session = session
    }

    func getHymn(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]?) -> AnyPublisher<Hymn, ErrorType> {
        guard let url = HymnalApi.getHymnUrl(hymnType: hymnType, hymnNumber: hymnNumber, queryParams: queryParams) else {
            let error = ErrorType.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                Just(pair.data)
                    .decode(type: Hymn.self, decoder: self.decoder)
                    .mapError { error in
                        .parsing(description: error.localizedDescription)
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}

private struct HymnalApi {
    private static let scheme = "http"
    private static let host = "hymnalnetapi.herokuapp.com"
}

private extension HymnalApi {
    static func getHymnUrl(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]?) -> URL? {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        components.path = "/v2/hymn/\(hymnType.abbreviatedValue)/\(hymnNumber)"
        if let queryParams = queryParams, !queryParams.isEmpty {
            components.queryItems = queryParams.compactMap({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: value)
            })
        }
        return components.url
    }
}

extension Resolver {
    public static func registerHymnalApiService() {
        register {HymnalApiServiceImpl(decoder: resolve(), session: resolve()) as HymnalApiService}.scope(application)
        register(JSONDecoder.self, factory: {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        })
        register {URLSession.shared}.scope(application)
    }
}
