import Foundation
import SwiftUI

class SongResultViewModel: Identifiable, Equatable {

    let title: String
    let destinationView: AnyView

    init (title: String, destinationView: AnyView) {
        self.title = title
        self.destinationView = destinationView
    }
}

extension SongResultViewModel {
    static func == (lhs: SongResultViewModel, rhs: SongResultViewModel) -> Bool {
        lhs.title == rhs.title
    }
}
