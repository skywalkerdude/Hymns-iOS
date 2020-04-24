// swiftlint:disable all
import Danger
import DangerXCodeSummary // package: https://github.com/f-meloni/danger-swift-xcodesummary.git

let danger = Danger()

let files = danger.git.modifiedFiles.filter { $0.hasPrefix("Hymns") }
SwiftLint.lint(.files(files), inline: true, configFile: ".swiftlint.yml")

let summary = XCodeSummary(filePath: "result.json")

// Ensure no copyright header
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let swiftFilesWithCopyright = editedFiles.filter {
    $0.contains("Copyright") && ($0.fileType == .swift  || $0.fileType == .m)
}
for file in swiftFilesWithCopyright {
    fail(message: "Please remove this copyright header", file: file, line: 0)
}

// Encourage smaller PRs
var bigPRThreshold = 1000;
if (danger.github.pullRequest.additions! + danger.github.pullRequest.deletions! > bigPRThreshold) {
    warn("> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.");
}
