import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagListViewModel: ObservableObject {

    typealias Tag = String

    @Published var tags: [Tag]?

    private let mainQueue: DispatchQueue
    private let tagStore: TagStore

    private var disposables = Set<AnyCancellable>()

    init(mainQueue: DispatchQueue = Resolver.resolve(name: "main"), tagStore: TagStore = Resolver.resolve()) {
        self.mainQueue = mainQueue
        self.tagStore = tagStore
    }

    func fetchUniqueTags() {
        tagStore.getUniqueTags()
            .replaceError(with: [Tag]())
            .receive(on: mainQueue)
            .sink(receiveValue: { tags in
                self.tags = tags
            }).store(in: &disposables)
    }
}

extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
