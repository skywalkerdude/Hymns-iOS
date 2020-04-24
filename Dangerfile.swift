// swiftlint:disable all
import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git

let danger = Danger()

let files = danger.git.modifiedFiles.filter { $0.hasPrefix("Hymns") }
SwiftLint.lint(.files(files), inline: true, configFile: ".swiftlint.yml")

