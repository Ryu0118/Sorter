import Foundation
@testable import SorterCore
import SwiftParser
import XCTest

final class SorterTests: XCTestCase {
    func testEnumSortRewriter() {
        let `enum` =
        """
        enum E1 {
            case b
            case a
            case j
            case h
            case i
            case e
            case d
            case g
            case f
            case c
        }
        """
        let expected =
        """
        enum E1 {
            case a
            case b
            case c
            case d
            case e
            case f
            case g
            case h
            case i
            case j
        }
        """

        let syntax = Parser.parse(source: `enum`)
        let formatted = EnumSortRewriter().visit(syntax)

        XCTAssertEqual(formatted.description, expected)
    }

    func testImportSortRewriter() {
        let `import` =
        """
        import UIKit
        import SwiftUI
        import ComposableArchitecture
        import CoreData
        import class UIKit.UIImage
        """
        let expected =
        """
        import ComposableArchitecture
        import CoreData
        import SwiftUI
        import UIKit
        import class UIKit.UIImage
        """

        let syntax = Parser.parse(source: `import`)
        let formatted = ImportSortRewriter().visit(syntax)

        XCTAssertEqual(formatted.description, expected)
    }
}
