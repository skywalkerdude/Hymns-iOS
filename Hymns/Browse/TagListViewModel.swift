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

    func fetchUniqueTags() {
        let result: Results<TagEntity> = tagStore.getUniqueTags()
        tags = result.map { (tagEntity) -> Tag in
            return tagEntity.tag
        }
    }
}

extension Resolver {
    public static func registerTagListViewModel() {
        register {TagListViewModel()}.scope(graph)
    }
}
