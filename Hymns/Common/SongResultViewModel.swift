import Foundation
import SwiftUI

class SongResultViewModel: Identifiable {

    let title: String
    let destinationView: AnyView

    init (title: String, destinationView: AnyView) {
        self.title = title
        self.destinationView = destinationView
    }
}
