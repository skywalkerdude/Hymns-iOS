import Foundation
import Resolver

class HomeViewModel: ObservableObject {

    @Published var recentSongs: [SongResultViewModel] = [SongResultViewModel]()

    init(recentSongs: [SongResultViewModel]) {
        // TODO fetch recent songs instead of passing it in
        self.recentSongs = [PreviewSongResults.cupOfChrist, PreviewSongResults.hymn1151]
    }
}

extension Resolver {
    public static func registerHomeViewModel() {
        register {HomeViewModel(recentSongs: [SongResultViewModel]())}.scope(graph)
    }
}
