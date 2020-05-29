import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class BrowseCategoriesViewModelSpec: QuickSpec {

    override func spec() {

        // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
        let testQueue = DispatchQueue(label: "test_queue")
        var categoriesRepository: CategoriesRepositoryMock!
        var target: BrowseCategoriesViewModel!

        describe("fetching categories") {
            beforeEach {
                categoriesRepository = mock(CategoriesRepository.self)
                target = BrowseCategoriesViewModel(hymnType: nil, backgroundQueue: testQueue, categoriesRepository: categoriesRepository, mainQueue: testQueue)
            }

            context("with results") {
                let categories = [CategoryEntity(category: "Category 1", subcategory: "Subcategory 1", count: 5),
                                  CategoryEntity(category: "Category 2", subcategory: "Subcategory 1", count: 6),
                                  CategoryEntity(category: "Category 1", subcategory: "Subcategory 3", count: 2),
                                  CategoryEntity(category: "Category 1", subcategory: "Subcategory 4", count: 5),
                                  CategoryEntity(category: "Category 3", subcategory: "Subcategory 20", count: 98),
                                  CategoryEntity(category: "Category 1", subcategory: "Subcategory 2", count: 738)]
                let currentValue = CurrentValueSubject<[CategoryEntity], ErrorType>(categories)
                beforeEach {
                    given(categoriesRepository.categories(by: nil)) ~> {_ in
                        currentValue.eraseToAnyPublisher()
                    }
                    target.fetchCategories()
                    testQueue.sync {}
                }
                it("should contain returned categories") {
                    let expected = [CategoryViewModel(category: "Category 2", subcategories: ["Subcategory 1"]),
                                    CategoryViewModel(category: "Category 3", subcategories: ["Subcategory 20"]),
                                    CategoryViewModel(category: "Category 1", subcategories: ["Subcategory 1", "Subcategory 3", "Subcategory 4", "Subcategory 2"])]
                    expect(target.categories).to(equal(expected))
                }
            }
        }
    }
}
