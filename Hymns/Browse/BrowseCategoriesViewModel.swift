import Combine
import Resolver

class BrowseCategoriesViewModel: ObservableObject {

    @Published var categories = [CategoryViewModel]()

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
                self.categories = categories.reduce(into: self.categories) { viewModels, entity in
                    guard let sameCategory = viewModels.first(where: { viewModel -> Bool in
                        viewModel.category == entity.category
                    }) else {
                        let viewModel = CategoryViewModel(category: entity.category, subcategories: [entity.subcategory])
                        viewModels.append(viewModel)
                        return
                    }

                    viewModels.removeAll { viewModel -> Bool in
                        viewModel == sameCategory
                    }
                    let newModel = CategoryViewModel(category: sameCategory.category, subcategories: sameCategory.subcategories + [entity.subcategory])
                    viewModels.append(newModel)
                }
            }).store(in: &disposables)
    }
}
