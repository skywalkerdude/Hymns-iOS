import Combine
import Foundation
import Resolver

/**
 * Repository to fetch a list of songs results, both from local storage and from the network.
 */
protocol SongResultsRepository {
    func search(searchParameter: String, pageNumber: Int?)  -> AnyPublisher<SongResultsPage?, Never>
}

class SongResultsRepositoryImpl: SongResultsRepository {

    private let hymnalApiService: HymnalApiService

    init(hymnalApiService: HymnalApiService) {
        self.hymnalApiService = hymnalApiService
    }

    func search(searchParameter: String, pageNumber: Int?) -> AnyPublisher<SongResultsPage?, Never> {
        return hymnalApiService.search(for: searchParameter, onPage: pageNumber)
            .map({(songResultsPage) -> SongResultsPage? in
                return songResultsPage
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
