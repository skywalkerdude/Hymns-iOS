import Foundation
import SwiftUI

public protocol TabItem: Identifiable, Equatable {

    associatedtype Label: View
    associatedtype Content: View

    var label: Label { get }
    var a11yLabel: Text { get }
    var content: Content { get }
}
