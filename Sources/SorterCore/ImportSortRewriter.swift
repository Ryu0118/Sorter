import Foundation
import SwiftSyntax

final class ImportSortRewriter: Rewriter, RuleNameContainable {
    static let ruleName: String = "import_sort"

    override func visit(_ node: CodeBlockItemListSyntax) -> CodeBlockItemListSyntax {
        let imports = node
            .enumerated()
            .compactMap { index, element -> ImportCodeBlock? in
                if let importDecl = element.item.as(ImportDeclSyntax.self) {
                    return ImportCodeBlock(index: index, importDecl: importDecl)
                } else {
                    return nil
                }
            }

        guard !imports.isEmpty else {
            return super.visit(node)
        }

        let formattedImports = imports
            .sorted {
                let first = $0.importDecl.path.trimmed.description
                let second = $1.importDecl.path.trimmed.description
                return first.localizedStandardCompare(second) == .orderedAscending
            }
            .inoutEnumeratedMap { index, element in
                let importDecl = imports[index].importDecl
                element.importDecl.leadingTrivia = importDecl.leadingTrivia
                element.importDecl.trailingTrivia = importDecl.trailingTrivia
            }

        let formattedItems = node
            .enumerated()
            .map { index, codeBlockItem in
                if let formattedImport = formattedImports[safe: index] {
                    return codeBlockItem.with(\.item, formattedImport.importDecl.cast(CodeBlockItemSyntax.Item.self))
                } else {
                    return codeBlockItem
                }
            }

        return super.visit(CodeBlockItemListSyntax(formattedItems))
    }
}

extension ImportSortRewriter {
    struct ImportCodeBlock {
        let index: Int
        var importDecl: ImportDeclSyntax
    }
}
