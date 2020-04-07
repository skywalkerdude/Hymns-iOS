import Combine
import Foundation
import Resolver

class HymnLyricsViewModel: ObservableObject {
    
    @Published var lyrics: [Verse]? = [Verse]()
    
    private var disposables = Set<AnyCancellable>()
    
    init(identifier: HymnIdentifier, hymnsRepository: HymnsRepository, callbackQueue: DispatchQueue) {
        hymnsRepository
            .getHymn(hymnIdentifier: identifier)
            .map({ (hymn) -> [Verse]? in
                guard let hymn = hymn, !hymn.lyrics.isEmpty else {
                    return nil
                }
                return hymn.lyrics
            })
            .receive(on: callbackQueue)
            .sink(
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
