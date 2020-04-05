import Combine
import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {
    
    @Published var lyrics: [Verse]? = [Verse]()

    private var disposables = Set<AnyCancellable>()
    
    init(hymnsRepository: HymnsRepository) {
        hymnsRepository
            .getHymn(hymnIdentifier: HymnIdentifier(hymnType: .classic, hymnNumber: "1151"))
            .map({ (hymn) -> [Verse]? in
                guard let hymn = hymn, !hymn.lyrics.isEmpty else {
                    return nil
                }
                return hymn.lyrics
            }).sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.lyrics = nil
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] lyrics in
                    self?.lyrics = lyrics
            }).store(in: &disposables)
    }
}

extension Resolver {
    public static func registerHymnLyricsViewModel() {
        register {HymnLyricsViewModel(hymnsRepository: resolve())}.scope(graph)
    }
}
