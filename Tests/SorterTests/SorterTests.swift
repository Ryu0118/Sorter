// 
//  SorterTests.swift
//  
//
//  Created by ryunosuke.shibuya on 2023/05/20.
//

import Foundation
import XCTest
@testable import SorterCore
import SwiftParser

final class SorterTests: XCTestCase {
    func testEmptyRewriter() {

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
}
