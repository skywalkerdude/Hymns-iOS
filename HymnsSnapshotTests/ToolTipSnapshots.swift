import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class ToolTipSnapshots: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_toolTipShape_filled() {
        assertSnapshot(matching: ToolTip(cornerRadius: 15, toolTipMidX: 300).fill(), as: .image())
    }

    func test_toolTipShape_oulined() {
        assertSnapshot(matching: ToolTip(cornerRadius: 15, toolTipMidX: 300).stroke(), as: .image())
    }
}
