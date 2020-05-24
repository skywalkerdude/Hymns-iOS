import Combine
import Resolver

class SongInfoViewModel: ObservableObject {

    @Published var label = ""
    @Published var values = [String]()

    init(label: String, values: [String]) {
        self.label = label
        self.values = values
    }
}

extension SongInfoViewModel: Hashable, Equatable {
    static func == (lhs: SongInfoViewModel, rhs: SongInfoViewModel) -> Bool {
        lhs.label == rhs.label && lhs.values == rhs.values
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(values)
    }
}

extension SongInfoViewModel: CustomStringConvertible {
    var description: String { "\(label): \(values)" }
}
