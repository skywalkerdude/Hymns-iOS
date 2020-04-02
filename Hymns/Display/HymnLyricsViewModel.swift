import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {
    
    @Published var lyrics: [Verse]? = [Verse]()
    
    @Injected private var hymnsRepository: HymnsRepository
    
    init() {
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
        register {HymnLyricsViewModel()}.scope(graph)
    }
}
