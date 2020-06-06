import Combine
import SwiftUI
import RealmSwift
import Resolver

class TagListViewModel: ObservableObject {

    typealias Tag = String

    @Published var tags = [Tag]()

    private let tagStore: TagStore

    init(tagStore: TagStore = Resolver.resolve()) {
        self.tagStore = tagStore
    }

    func getUniqueTags() {
        tags = tagStore.getUniqueTags()
    }
}

extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
