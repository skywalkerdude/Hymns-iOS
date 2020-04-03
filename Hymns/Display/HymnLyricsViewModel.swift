import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {
    
    @Published var lyrics: [Verse]? = [Verse]()
    
    init(hymnsRepository: HymnsRepository) {
        hymnsRepository.getHymn(hymnIdentifier: HymnIdentifier(hymnType: .classic, hymnNumber: "1151")) { hymn in
            guard let hymn = hymn, !hymn.lyrics.isEmpty else {
                self.lyrics = nil
                return
            }
            
            self.lyrics = hymn.lyrics
        }
    }
}

extension Resolver {
    public static func registerHymnLyricsViewModel() {
        register {HymnLyricsViewModel(hymnsRepository: resolve())}.scope(graph)
    }
}
