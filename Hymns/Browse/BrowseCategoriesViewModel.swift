import Combine
import Resolver

class BrowseCategoriesViewModel: ObservableObject {

    @Published var categories: [CategoryViewModel]? = [CategoryViewModel]()

    private let analytics: AnalyticsLogger
    private let backgroundQueue: DispatchQueue
    private let categoriesRepository: CategoriesRepository
    private let hymnType: HymnType?
    private let mainQueue: DispatchQueue

    private var disposables = Set<AnyCancellable>()

    init(hymnType: HymnType?,
         analytics: AnalyticsLogger = Resolver.resolve(),
         backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         categoriesRepository: CategoriesRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.analytics = analytics
        self.backgroundQueue = backgroundQueue
        self.categoriesRepository = categoriesRepository
        self.hymnType = hymnType
        self.mainQueue = mainQueue
    }

    func fetchCategories() {
        categoriesRepository
            .categories(by: hymnType)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { categories in
                guard !categories.isEmpty else {
                    self.categories = nil
                    return
                }

                let categoryViewModels = categories.reduce(into: [CategoryViewModel]()) { viewModels, entity in
                    guard let sameCategory = viewModels.first(where: { viewModel -> Bool in
                        viewModel.category == entity.category
                    }) else {
                        let viewModel = CategoryViewModel(category: entity.category,
                                                          subcategories: [SubcategoryViewModel(subcategory: entity.subcategory, count: entity.count)])
                        viewModels.append(viewModel)
                        return
                    }
                    sameCategory.subcategories.append(SubcategoryViewModel(subcategory: entity.subcategory, count: entity.count))
                }

                // Add the "All subcategories" section to each categoryViewModel
                self.categories = categoryViewModels.map({ categoryViewModel -> CategoryViewModel in
                    let total = categoryViewModel.subcategories.reduce(0) { (totalSoFar, subcategory) -> Int in
                        return totalSoFar + subcategory.count
                    }
                    categoryViewModel.subcategories.insert(SubcategoryViewModel(subcategory: nil, count: total), at: 0)
                    return categoryViewModel
                })
            }).store(in: &disposables)
    }
}
