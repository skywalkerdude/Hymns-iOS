import Foundation
import Alamofire
import Resolver

class HymnalApiService {
    
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
        register {HymnalApiService(jsonDecoder: resolve())}.scope(application)
        register {JSONDecoder()}.scope(application)
    }
}
