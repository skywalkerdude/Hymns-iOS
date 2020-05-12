// swiftlint:disable all
import Foundation
import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git
extension FileManager {
    func modificationDate(forFileAtPath path: String) -> Date? {
        guard let attributes = try? attributesOfItem(atPath: path) else {
            return nil
        }

        return attributes[.modificationDate] as? Date
    }
}

func findXcresultFilePath() -> String {
    let fileManager: FileManager = .default

    let archives = try! fileManager.contentsOfDirectory(atPath: ".").filter({ name -> Bool in
        name.starts(with: "Hymns-")
    })
    print("archives: \(archives)")

    let lastModifiedArchive = archives.sorted(by: { (left, right) -> Bool in
        let leftModificationDate = fileManager.modificationDate(forFileAtPath: left)?.timeIntervalSince1970 ?? 0
        let rightModificationDate = fileManager.modificationDate(forFileAtPath: right)?.timeIntervalSince1970 ?? 0
        return leftModificationDate > rightModificationDate
    }).first!
    print("lastModifiedArchive: \(lastModifiedArchive)")

    let testFolder = lastModifiedArchive + "/Logs/Test/"
    print("testFolder: \(testFolder)")
    let xcresults = try! fileManager.contentsOfDirectory(atPath: testFolder).filter({ $0.split(separator: ".").last == "xcresult" })
    print("xcresults: \(xcresults)")

    let lastModifiedXcresult =  xcresults.sorted(by: { (left, right) -> Bool in
        let leftModificationDate = fileManager.modificationDate(forFileAtPath: testFolder + left)?.timeIntervalSince1970 ?? 0
        let rightModificationDate = fileManager.modificationDate(forFileAtPath: testFolder + right)?.timeIntervalSince1970 ?? 0
        return leftModificationDate > rightModificationDate
    }).first!
    print("lastModifiedXcresult: \(lastModifiedXcresult)")
    return testFolder + lastModifiedXcresult
}

let xcresultFilePath = try findXcresultFilePath()
print(xcresultFilePath)
//    Coverage.xcodeBuildCoverage(.xcresultBundle(xcresultFilePath), minimumCoverage: 50, excludedTargets: ["HymnTests.xctest", "HymnsUITests.xctest"])
}
