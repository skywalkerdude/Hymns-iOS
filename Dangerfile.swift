// swiftlint:disable all
import Danger
import DangerXCodeSummary // package: [https://github.com/f-meloni/danger-swift-xcodesummary.git]

let danger = Danger()

let files = danger.git.modifiedFiles.filter { $0.hasPrefix("Hymns") }
SwiftLint.lint(.files(files), inline: true, configFile: ".swiftlint.yml")

//let summary = XCodeSummary(filePath: "result.json")
