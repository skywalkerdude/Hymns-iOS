import Foundation
import SwiftUI

public protocol TabItem: Identifiable, Equatable {

    associatedtype SelectedLabel: View
    associatedtype UnselectedLabel: View
    associatedtype Content: View

    var selectedLabel: SelectedLabel { get }
    var unselectedLabel: UnselectedLabel { get }
    var a11yLabel: Text { get }
    var content: Content { get }
}
