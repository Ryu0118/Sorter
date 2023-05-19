// 
//  Sorter.swift
//  
//
//  Created by ryunosuke.shibuya on 2023/05/19.
//

import Foundation
import SwiftParser

public enum Sorter {
    public static func sort(fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        let syntax = SwiftParser.Parser.parse(source: String(data: data, encoding: .utf8) ?? "")
        let formatted = EnumSortRewriter().visit(syntax)
        try formatted.description.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    public static func sortRecursively(directory: URL) throws {
        guard let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
            throw SorterError.fileEnumeratorNotFound
        }

        for case let fileURL as URL in enumerator {
            let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
            if fileAttributes.isRegularFile!, fileURL.pathExtension == "swift" {
                try sort(fileURL: fileURL)
            }
        }
    }
}

enum SorterError: LocalizedError {
    case fileEnumeratorNotFound
}
