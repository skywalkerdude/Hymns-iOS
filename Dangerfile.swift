// swiftlint:disable all
import Danger

let danger = Danger()

// Ensure no copyright header
let changedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let swiftFilesWithCopyright = changedFiles.filter {
    $0.fileType == .swift && danger.utils.readFile($0).contains("//  Created by")
}
if swiftFilesWithCopyright.count > 0 {
    let files = swiftFilesWithCopyright.joined(separator: ", ")
    fail("Please remove the copyright header in: \(files)")
}

// Encourage smaller PRs
var bigPRThreshold = 1000;
if (danger.github.pullRequest.additions! + danger.github.pullRequest.deletions! > bigPRThreshold) {
    warn("> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.");
}
