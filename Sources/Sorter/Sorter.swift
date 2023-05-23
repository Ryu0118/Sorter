import ArgumentParser
import Foundation
import SorterCore

@main
struct Sorter: ParsableCommand {
    @Option(name: .shortAndLong, help: "Swift file path you want to sort")
    var file: String?

    @Option(name: .shortAndLong, help: "Project Path you want to sort")
    var project: String?

    @Option(name: .customLong("rule-path"), help: "Explicitly specify the path to the file in which the rules to be enabled are listed")
    var rulePath: String?

    @Option(name: .long, help: "Specify the rule. To specify multiple rules, write rules separated by commas.")
    var rules: String?

    static let _commandName: String = "sorter"

    mutating func run() throws {
        if let file {
            if let rulePath {
                try SorterCore.Sorter.sort(fileURL: URL(fileURLWithPath: file), rulePath: rulePath)
            }
            else if let rules {
                try SorterCore.Sorter.sort(fileURL: URL(fileURLWithPath: file), rules: rules)
            }
            else {
                try SorterCore.Sorter.sort(fileURL: URL(fileURLWithPath: file))
            }
        }
        else if let project {
            if let rules {
                try SorterCore.Sorter.sortRecursively(directory: URL(fileURLWithPath: project), rules: rules)
            }
            else {
                try SorterCore.Sorter.sortRecursively(directory: URL(fileURLWithPath: project), rulePath: rulePath)
            }
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
        else if let rulePath, !FileManager.default.fileExists(atPath: rulePath) {
            throw SorterError.ruleFileNotFound(path: rulePath)
        }
    }
}

enum SorterError: LocalizedError {
    case notDirectory(path: String)
    case notFile(path: String)
    case projectNotFound(path: String)
    case ruleFileNotFound(path: String)

    var errorDescription: String? {
        switch self {
        case .projectNotFound(let path):
            return "\(path) could not be found"

        case .ruleFileNotFound(let path):
            return "\(path) could not be found"

        case .notDirectory(let path):
            return "\(path) is not a directory"

        case .notFile(let path):
            return "\(path) is a directory"
        }
    }
}
