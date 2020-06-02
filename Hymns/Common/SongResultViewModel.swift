import Foundation
import SwiftUI

class SongResultViewModel: Identifiable {

    let title: String
    let destinationView: AnyView

    init(title: String, destinationView: AnyView) {
        self.title = title
        self.destinationView = destinationView
    }
}

extension SongResultViewModel: Hashable {
    static func == (lhs: SongResultViewModel, rhs: SongResultViewModel) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
