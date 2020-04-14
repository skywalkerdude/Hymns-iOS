// swiftlint:disable all
import Danger

let danger = Danger()

// FAILS with https://github.com/danger/swift/issues/339 SwiftLint.lint(configFile: ".swiftlint.yml", swiftlintPath: "Pods/SwiftLint/swiftlint")
// This works though, for some reason SwiftLint.lint(.modifiedAndCreatedFiles(directory:"HymnsTests"), configFile: ".swiftlint.yml", swiftlintPath: "Pods/SwiftLint/swiftlint")

// Ensure no copyright header
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let swiftFilesWithCopyright = editedFiles.filter {
    $0.contains("Copyright") && ($0.fileType == .swift  || $0.fileType == .m)
}
for file in swiftFilesWithCopyright {
    fail(message: "Please remove this copyright header", file: file, line: 0)
}

// Encourage smaller PRs
var bigPRThreshold = 600;
if (danger.github.pullRequest.additions! + danger.github.pullRequest.deletions! > bigPRThreshold) {
    warn("> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.");
}
