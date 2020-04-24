// swiftlint:disable all
import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git

let danger = Danger()

Coverage.xcodeBuildCoverage(.derivedDataFolder("Build"),
                            minimumCoverage: 50,
                            excludedTargets: ["DangerSwiftCoverageTests.xctest"])
