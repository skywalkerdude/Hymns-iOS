import Combine
import Foundation
import Resolver

/**
 * Repository to fetch a list of songs results, both from local storage and from the network.
 */
protocol CategoriesRepository {
    func categories(by hymnType: HymnType?)  -> AnyPublisher<[CategoryEntity], ErrorType>
}

class CategoriesRepositoryImpl: CategoriesRepository {

    private let dataStore: HymnDataStore

    init(dataStore: HymnDataStore = Resolver.resolve()) {
        self.dataStore = dataStore
    }

    func categories(by hymnType: HymnType?)  -> AnyPublisher<[CategoryEntity], ErrorType> {
        if let hymnType = hymnType {
            return dataStore.getCategories(by: hymnType)
        } else {
            return dataStore.getAllCategories()
        }
    }
}
