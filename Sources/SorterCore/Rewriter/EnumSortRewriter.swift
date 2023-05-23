import Foundation
import SwiftSyntax

final class EnumSortRewriter: Rewriter, RuleNameContainable {
    static let ruleName: String = "enum_case"

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        var members = node.memberBlock.members
        var enumCases = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let otherDeclIndexes = members
            .enumerated()
            .compactMap { index, member in
                if member.decl.as(EnumCaseDeclSyntax.self) == nil {
                    return index
                } else {
                    return nil
                }
            }

        var elementLists = enumCases.map(\.elements)

        // enum E1 {
        //     case c1, c2, c3
        // }
        if let elementList = elementLists.first,
           elementLists.count == 1
        {
            let sortedList = sortElementList(elementList)
            elementLists = [sortedList]
        } else {
            // Enum E1 {
            //     case c1
            //     case c2
            //     case c3
            // }
            elementLists = sortElementLists(elementLists)
        }

        enumCases = zip(enumCases, elementLists).map {
            $0.with(\.elements, $1)
        }

        members = MemberDeclListSyntax(
            zip(members, enumCases).map {
                $0.with(\.decl, $1.cast(DeclSyntax.self))
            }
        )
        .inserting(otherDeclIndexes.map { ($0, members.array[$0]) })

        return super.visit(node.with(\.memberBlock.members, members))
    }

    /// Enum E1 {
    ///     case c1
    ///     case c2
    ///     case c3
    /// }
    private func sortElementLists(_ elementLists: [EnumCaseElementListSyntax]) -> [EnumCaseElementListSyntax] {
        elementLists.sorted {
            let firstText = $0.first?.identifier.text ?? ""
            let secondText = $1.first?.identifier.text ?? ""
            return firstText.localizedStandardCompare(secondText) == .orderedAscending
        }
    }

    /// enum E1 {
    ///     case c1, c2, c3
    /// }
    private func sortElementList(_ elementList: EnumCaseElementListSyntax) -> EnumCaseElementListSyntax {
        let elements = elementList
            .sorted {
                $0.identifier.text.localizedStandardCompare($1.identifier.text) == .orderedAscending
            }
            .inoutEnumeratedMap { index, element in
                if index == elementList.count - 1 {
                    element.trailingComma = nil
                } else {
                    element.trailingComma = .commaToken(trailingTrivia: .space)
                }
            }

        return EnumCaseElementListSyntax(elements)
    }
}

extension MemberDeclListSyntax {
    func inserting(_ elements: [(Int, Element)]) -> MemberDeclListSyntax {
        var copy = self
        for (at, element) in elements.sorted(by: { $0.0 < $1.0 }) {
            copy = copy.inserting(element, at: at)
        }
        return copy
    }
}

extension SyntaxCollection {
    var array: [Element] {
        Array(self)
    }
}
