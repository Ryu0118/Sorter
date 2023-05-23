import Foundation

enum RewriterProvider {
    static let allRewriters: [any RuleNameContainable.Type] = [
        EnumSortRewriter.self,
        ImportSortRewriter.self
    ]

    static let all = allRewriters.map { $0.init() }

    static func provide(from ruleFileDirectory: URL) throws -> [any RuleNameContainable] {
        let rule = try loadRuleFile(directory: ruleFileDirectory)
        return try provide(rule)
    }

    static func provide(_ rule: Rule) throws -> [any RuleNameContainable] {
        try rule.enabled.map { ruleName in
            if let rewriter = allRewriters.first(where: { $0.ruleName == ruleName }) {
                return rewriter.init()
            } else {
                throw RewriterProviderError.cannotFindRule(name: ruleName)
            }
        }
    }

    private static func loadRuleFile(directory: URL) throws -> Rule {
        if FileManager.default.fileExists(atPath: directory.pathComponents.joined(separator: "/")) {
            let content = try Data(contentsOf: directory)
            let string = String(data: content, encoding: .utf8) ?? ""
            let ruleNames = string
                .components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            return Rule(enabled: ruleNames)
        } else {
            return Rule(enabled: allRewriters.map { $0.ruleName })
        }
    }
}

enum RewriterProviderError: LocalizedError {
    case cannotFindRule(name: String)

    var errorDescription: String? {
        switch self {
        case .cannotFindRule(let name):
            return "rule: \(name) does not exist."
        }
    }
}
