// swiftlint:disable all
import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git

// Generate coverage data
Coverage.xcodeBuildCoverage(.xcresultBundle("Hymns-*/Logs/Test/*.xcresult"), minimumCoverage: 50, excludedTargets: ["HymnTests.xctest", "HymnsUITests.xctest"])
