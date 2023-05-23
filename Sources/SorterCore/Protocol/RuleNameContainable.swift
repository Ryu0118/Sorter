import Foundation
import SwiftSyntax

protocol RuleNameContainable: Rewriter {
    static var ruleName: String { get }
}
