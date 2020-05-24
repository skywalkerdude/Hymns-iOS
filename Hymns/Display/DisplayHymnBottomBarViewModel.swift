import Combine
import Foundation
import Resolver

class DisplayHymnBottomBarViewModel: ObservableObject {

    @Published var songInfo: SongInfoDialogViewModel

    private let identifier: HymnIdentifier

    init(hymnToDisplay identifier: HymnIdentifier) {
        self.identifier = identifier
        self.songInfo = SongInfoDialogViewModel(hymnToDisplay: identifier)
    }
}

extension DisplayHymnBottomBarViewModel: Equatable {
    static func == (lhs: DisplayHymnBottomBarViewModel, rhs: DisplayHymnBottomBarViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
