import Resolver

class AllSongsViewModel: ObservableObject {

    @Published var hymnTypes: [HymnType]

    init() {
        hymnTypes = [.classic, .newSong, .children, .howardHigashi, .dutch, .german, .chinese, .chineseSupplement,
                     .cebuano, .tagalog, .french, .spanish, .korean, .japanese]
    }
}

extension Resolver {
    public static func registerAllSongsViewModel() {
        register {AllSongsViewModel()}.scope(graph)
    }
}
