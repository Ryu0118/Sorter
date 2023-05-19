import ArgumentParser
import Foundation
import SorterCore

@main
struct Sorter: ParsableCommand {
    @Option(name: .shortAndLong, help: "Swift file path you want to sort")
    var file: String?

    @Option(name: .shortAndLong, help: "Project Path you want to sort")
    var project: String?

    static let _commandName: String = "sorter"

    mutating func run() throws {
        if let file {
            try SorterCore.Sorter.sort(fileURL: URL(fileURLWithPath: file))
        }
        else if let project {
            try SorterCore.Sorter.sortRecursively(directory: URL(fileURLWithPath: project))
        }
    }

    mutating func validate() throws {
        if file == nil && project == nil {
            throw CleanExit.helpRequest(self)
        }
        else if let project, !FileManager.default.fileExists(atPath: project) {
            throw SorterError.projectNotFound(path: project)
        }
        else if let project, !URL(fileURLWithPath: project).hasDirectoryPath {
            throw SorterError.notDirectory(path: project)
        }
        else if let file, URL(fileURLWithPath: file).hasDirectoryPath {
            throw SorterError.notFile(path: file)
        }
    }
}

enum SorterError: LocalizedError {
    case projectNotFound(path: String)
    case notDirectory(path: String)
    case notFile(path: String)

    var errorDescription: String? {
        switch self {
        case .projectNotFound(let path):
            return "\(path) could not be found"

        case .notDirectory(let path):
            return "\(path) is not a directory"

        case .notFile(let path):
            return "\(path) is a directory"
        }
    }
}
