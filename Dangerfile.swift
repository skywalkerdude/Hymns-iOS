// swiftlint:disable all
import Foundation
import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git

enum CustomError: Error {
    case notFound(description: String)
}

extension FileManager {
    func modificationDate(forFileAtPath path: String) -> Date? {
        guard let attributes = try? attributesOfItem(atPath: path) else {
            return nil
        }

        return attributes[.modificationDate] as? Date
    }
}

func findXcresultFilePath() throws -> String {
    let fileManager: FileManager = .default

    guard let archives = try? fileManager.contentsOfDirectory(atPath: ".").filter({ name -> Bool in
        name.starts(with: "Hymns-")
    }) else {
        throw CustomError.notFound(description: "Unable to find downloaded archive")
    }
    print("archives: \(archives)")

    guard let lastModifiedArchive = archives.sorted(by: { (left, right) -> Bool in
        let leftModificationDate = fileManager.modificationDate(forFileAtPath: left)?.timeIntervalSince1970 ?? 0
        let rightModificationDate = fileManager.modificationDate(forFileAtPath: right)?.timeIntervalSince1970 ?? 0
        return leftModificationDate > rightModificationDate
    }).first else {
        throw CustomError.notFound(description: "There was no lastModifiedArchive")
    }
    print("lastModifiedArchive: \(lastModifiedArchive)")

    let testFolder = lastModifiedArchive + "/Logs/Test/"
    print("testFolder: \(testFolder)")
    guard let xcresults = try? fileManager.contentsOfDirectory(atPath: testFolder).filter({ $0.split(separator: ".").last == "xcresult" }),
        !xcresults.isEmpty else {
            throw CustomError.notFound(description: "no xcresult in \(testFolder)")
    }
    print("xcresults: \(xcresults)")

    guard let lastModifiedXcresult =  xcresults.sorted(by: { (left, right) -> Bool in
        let leftModificationDate = fileManager.modificationDate(forFileAtPath: testFolder + left)?.timeIntervalSince1970 ?? 0
        let rightModificationDate = fileManager.modificationDate(forFileAtPath: testFolder + right)?.timeIntervalSince1970 ?? 0
        return leftModificationDate > rightModificationDate
    }).first else {
        throw CustomError.notFound(description: "There was no lastModifiedXcresult")
    }
    print("lastModifiedXcresult: \(lastModifiedXcresult)")
    return testFolder + lastModifiedXcresult
}

do {
    let xcresultFilePath = try findXcresultFilePath()
    print(xcresultFilePath)
//    Coverage.xcodeBuildCoverage(.xcresultBundle(xcresultFilePath), minimumCoverage: 50, excludedTargets: ["HymnTests.xctest", "HymnsUITests.xctest"])
} catch {
    fail("Failed to find the .xcresult file")
}
