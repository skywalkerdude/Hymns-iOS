import Foundation
import Alamofire
import Resolver

/**
 * Service to contact the Hymnal API.
 */
protocol HymnalApiService {
    func getHymn(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]?, _ callback: @escaping (Hymn?) -> Void)
}

/**
 * Implementation of HymnalApiService that uses Alamofire.
 */
class HymnalApiServiceAlamofireImpl: HymnalApiService {
    
    private let baseAuthority = "http://hymnalnetapi.herokuapp.com"
    
    private let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getHymn(hymnType: HymnType, hymnNumber: String, queryParams: [String: String]?, _ callback: @escaping (Hymn?) -> Void) {
        let url = baseAuthority + "/v2/hymn/\(hymnType.abbreviatedValue)/\(hymnNumber)"
        AF.request(url, parameters: queryParams).validate().responseDecodable(of: Hymn.self, decoder: jsonDecoder) { hymn in
            callback(hymn.value)
        }
    }
}

extension Resolver {
    public static func registerHymnalApiService() {
        register {HymnalApiServiceAlamofireImpl(jsonDecoder: resolve()) as HymnalApiService}.scope(application)
        register {JSONDecoder()}.scope(application)
    }
}
