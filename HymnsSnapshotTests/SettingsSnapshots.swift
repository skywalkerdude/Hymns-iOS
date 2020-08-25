import SnapshotTesting
import SwiftUI
import XCTest
@testable import Hymns

// https://troz.net/post/2020/swiftui_snapshots/
class SettingsSnapshots: XCTestCase {

    var viewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
    }

    func test_error() {
        viewModel.settings = nil
        assertSnapshot(matching: SettingsView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_loading() {
        assertSnapshot(matching: SettingsView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_settings() {
        viewModel.settings = [.privacyPolicy, .feedback(.constant(nil)), .aboutUs]
        assertSnapshot(matching: SettingsView(viewModel: viewModel), as: .swiftUiImage())
    }

    func test_privacyPolicy() {
        assertSnapshot(matching: PrivacyPolicyView(showPrivacyPolicy: .constant(true)), as: .swiftUiImage(),
                       timeout: 60)
    }
}
