import Foundation
import SwiftParser
import SwiftSyntax

public enum Sorter {
    public static func sort(fileURL: URL) throws {
        try sort(fileURL: fileURL, rewriter: RewriterProvider.all)
    }

    public static func sort(fileURL: URL, rulePath: String) throws {
        let ruleURL = URL(fileURLWithPath: rulePath)
        let rewriters = try RewriterProvider.provide(from: ruleURL)

        try sort(fileURL: fileURL, rewriter: rewriters)
    }

    public static func sort(fileURL: URL, rules: String) throws {
        let ruleNames = rules.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let rule = Rule(enabled: ruleNames)
        let rewriters = try RewriterProvider.provide(rule)

        try sort(fileURL: fileURL, rewriter: rewriters)
    }

    public static func sortRecursively(directory: URL, rulePath: String? = nil) throws {
        let ruleURL: URL
        if let rulePath {
            ruleURL = URL(fileURLWithPath: rulePath)
        } else {
            ruleURL = directory.appendingPathComponent("sorter")
        }

        let rewriters = try RewriterProvider.provide(from: ruleURL)

        try sortRecursively(directory: directory, rewriters: rewriters)
    }

    public static func sortRecursively(directory: URL, rules: String) throws {
        let ruleNames = rules.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let rule = Rule(enabled: ruleNames)
        let rewriters = try RewriterProvider.provide(rule)

        try sortRecursively(directory: directory, rewriters: rewriters)
    }

    private static func sortRecursively(directory: URL, rewriters: [Rewriter]) throws {
        guard let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
            throw SorterError.fileEnumeratorNotFound
        }

        for case let fileURL as URL in enumerator {
            let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
            if fileAttributes.isRegularFile!, fileURL.pathExtension == "swift" {
                try sort(fileURL: fileURL, rewriter: rewriters)
            }
        }
    }

    private static func sort(fileURL: URL, rewriter: [Rewriter]) throws {
        let data = try Data(contentsOf: fileURL)
        let syntax = SwiftParser.Parser.parse(source: String(data: data, encoding: .utf8) ?? "")
        let formattedNode = rewriter.reduce(syntax) { partialResult, rewriter in
            rewriter.visit(partialResult)
        }
        try formattedNode.description.description.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

struct Rule {
    let enabled: [String]
}

enum SorterError: LocalizedError {
    case fileEnumeratorNotFound
}
