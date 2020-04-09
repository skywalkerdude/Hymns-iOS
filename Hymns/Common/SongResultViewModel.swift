import Foundation
import SwiftUI

class SongResultViewModel<DestinationView>: Identifiable where DestinationView: View {

    let title: String
    let destinationView: DestinationView

    init (title: String, destinationView: DestinationView) {
        self.title = title
        self.destinationView = destinationView
    }
}
