import Foundation
import Resolver

/*
 * Repository that stores all hymns that have been searched during this session in memory.
 */
class HymnsRepository: ObservableObject {
    
    @Injected private var hymnalApiService: HymnalApiService
    
    var hymns: [HymnIdentifier: Hymn] = [HymnIdentifier: Hymn]()
    
    init() {}
    
    func getHymn(hymnIdentifier: HymnIdentifier, _ callback: @escaping (Hymn?) -> Void) {
        if let hymn = hymns[hymnIdentifier] {
            callback(hymn)
            return
        }
        
        hymnalApiService.getHymn(hymnType: hymnIdentifier.hymnType, hymnNumber: hymnIdentifier.hymnNumber, queryParams: hymnIdentifier.queryParams) { hymn in
            guard let hymn = hymn else {
                callback(nil)
                return
            }
            
            self.hymns[hymnIdentifier] = hymn
            callback(hymn)
        }
    }
}
