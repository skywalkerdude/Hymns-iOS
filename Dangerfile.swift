// swiftlint:disable all
import Danger

let danger = Danger()

let files = danger.git.modifiedFiles.filter { $0.hasPrefix("Hymns") }

SwiftLint.lint(.files(files), inline: true, configFile: ".swiftlint.yml")

fail(message: "Please remove this copyright header", file: file, line: 0)

// Encourage smaller PRs
var bigPRThreshold = 1000;
if (danger.github.pullRequest.additions! + danger.github.pullRequest.deletions! > bigPRThreshold) {
    warn("> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.");
}
