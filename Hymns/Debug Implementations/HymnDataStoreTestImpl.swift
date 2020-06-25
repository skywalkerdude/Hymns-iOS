#if DEBUG
import Combine
import Foundation

class HymnDataStoreTestImpl: HymnDataStore {

    private var hymnStore = [classic1151: classic1151Entity]
    private var searchStore
        = ["search param":
            [SearchResultEntity(hymnType: .classic, hymnNumber: "1151", queryParams: nil, title: "Click me!", matchInfo: Data(repeating: 0, count: 8)),
             SearchResultEntity(hymnType: .chinese, hymnNumber: "4", queryParams: nil, title: "Don't click!", matchInfo: Data(repeating: 1, count: 8))]]

    var databaseInitializedProperly: Bool = true

    func saveHymn(_ entity: HymnEntity) {
        guard let hymnType = HymnType.fromAbbreviatedValue(entity.hymnType) else {
            fatalError()
        }
        let hymnIdentifier = HymnIdentifier(hymnType: hymnType, hymnNumber: entity.hymnNumber, queryParams: entity.queryParams.deserializeFromQueryParamString)
        hymnStore[hymnIdentifier] = entity
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType> {
        Just(hymnStore[hymnIdentifier]).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func searchHymn(_ searchParamter: String) -> AnyPublisher<[SearchResultEntity], ErrorType> {
        Just(searchStore[searchParamter] ?? [SearchResultEntity]()).mapError({ _ -> ErrorType in
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
