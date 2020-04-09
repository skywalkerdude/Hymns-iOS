import Combine
import Foundation
import Resolver

/**
 * Repository that stores all hymns that have been searched during this session in memory.
 */
protocol HymnsRepository {
    func getHymn(hymnIdentifier: HymnIdentifier)  -> AnyPublisher<Hymn?, Never>
}

class HymnsRepositoryImpl: HymnsRepository {

    private let hymnalApiService: HymnalApiService

    private var hymns: [HymnIdentifier: Hymn] = [HymnIdentifier: Hymn]()

    init(hymnalApiService: HymnalApiService) {
        self.hymnalApiService = hymnalApiService
    }

    func getHymn(hymnIdentifier: HymnIdentifier)  -> AnyPublisher<Hymn?, Never> {
        if let hymn = hymns[hymnIdentifier] {
            return Just(hymn).eraseToAnyPublisher()
        }
        return hymnalApiService.getHymn(hymnType: hymnIdentifier.hymnType, hymnNumber: hymnIdentifier.hymnNumber, queryParams: hymnIdentifier.queryParams)
            .map({ [weak self] (hymn) -> Hymn? in
                self?.hymns[hymnIdentifier] = hymn
                return hymn
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
