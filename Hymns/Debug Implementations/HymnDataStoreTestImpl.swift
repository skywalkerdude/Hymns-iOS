#if DEBUG
import Combine
import Foundation

class HymnDataStoreTestImpl: HymnDataStore {

    private var hymnStore = [classic1151: classic1151Entity]
    private var searchStore =
        ["search param":
            [SearchResultEntity(hymnType: .classic, hymnNumber: "1151", queryParams: nil, title: "Click me!", matchInfo: Data(repeating: 0, count: 8)),
             SearchResultEntity(hymnType: .chinese, hymnNumber: "4", queryParams: nil, title: "Don't click!", matchInfo: Data(repeating: 1, count: 8))]]
    private var categories =
        [CategoryEntity(category: "category 1", subcategory: "subcategory 1", count: 5),
         CategoryEntity(category: "category 1", subcategory: "subcategory 2", count: 1),
         CategoryEntity(category: "category 2", subcategory: "subcategory 1", count: 9)]
    private var songResultsBy =
        [("category 1 h subcategory 2"):
            [SongResultEntity(hymnType: .classic, hymnNumber: "1151", queryParams: nil, title: "Click me!"),
             SongResultEntity(hymnType: .newTune, hymnNumber: "37", queryParams: nil, title: "Don't click!"),
             SongResultEntity(hymnType: .classic, hymnNumber: "883", queryParams: nil, title: "Don't click either!")]]
    private var scriptureSongs =
        [ScriptureEntity(title: "booyah1", hymnType: .chinese, hymnNumber: "155", queryParams: nil, scriptures: "Hosea 14:8"),
         ScriptureEntity(title: "Click me!", hymnType: .classic, hymnNumber: "1151", queryParams: nil, scriptures: "Revelation 22"),
         ScriptureEntity(title: "Don't click me!", hymnType: .spanish, hymnNumber: "1151", queryParams: nil, scriptures: "Revelation"),
         ScriptureEntity(title: "booyah2", hymnType: .chinese, hymnNumber: "24", queryParams: nil, scriptures: "Genesis 1:26"),
         ScriptureEntity(title: "booyah3", hymnType: .chinese, hymnNumber: "33", queryParams: nil, scriptures: "Genesis 1:1")]

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
        Just(categories).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }

    func getResultsBy(category: String, hymnType: HymnType?, subcategory: String?) -> AnyPublisher<[SongResultEntity], ErrorType> {
        Just(songResultsBy["\(category) \(hymnType?.abbreviatedValue ?? "") \(subcategory ?? "")"] ?? [SongResultEntity]())
            .mapError({ _ -> ErrorType in
                .data(description: "This will never get called")
            }).eraseToAnyPublisher()
    }

    func getScriptureSongs() -> AnyPublisher<[ScriptureEntity], ErrorType> {
        Just(scriptureSongs).mapError({ _ -> ErrorType in
            .data(description: "This will never get called")
        }).eraseToAnyPublisher()
    }
}
#endif
