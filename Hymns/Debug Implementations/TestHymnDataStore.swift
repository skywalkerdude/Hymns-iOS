#if DEBUG
import Combine
import Foundation

class HymnDataStoreTestImpl: HymnDataStore {

    private var dataStore = [classic1151: classic1151Entity]

    var databaseInitializedProperly: Bool = true

    func saveHymn(_ entity: HymnEntity) {
        guard let hymnType = HymnType.fromAbbreviatedValue(entity.hymnType) else {
            fatalError()
        }
        let hymnIdentifier = HymnIdentifier(hymnType: hymnType, hymnNumber: entity.hymnNumber, queryParams: entity.queryParams.deserializeFromQueryParamString)
        dataStore[hymnIdentifier] = entity
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType> {
        Just(dataStore[hymnIdentifier]).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func searchHymn(_ searchParamter: String) -> AnyPublisher<[SearchResultEntity], ErrorType> {
        Just([SearchResultEntity]()).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func getAllCategories() -> AnyPublisher<[CategoryEntity], ErrorType> {
        Just([CategoryEntity]()).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func getCategories(by hymnType: HymnType) -> AnyPublisher<[CategoryEntity], ErrorType> {
        Just([CategoryEntity]()).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func getResultsBy(category: String, hymnType: HymnType?, subcategory: String?) -> AnyPublisher<[SongResultEntity], ErrorType> {
        Just([SongResultEntity]()).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func getScriptureSongs() -> AnyPublisher<[ScriptureEntity], ErrorType> {
        Just([ScriptureEntity]()).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }
}
#endif
