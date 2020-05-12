import Foundation
import SwiftUI

public protocol HymnLyricsTabItem: Identifiable, Equatable {

    associatedtype HymnTabLabel: View

    var hymnTabLabel: HymnTabLabel { get }
    var a11yLabel: Text { get }
}
