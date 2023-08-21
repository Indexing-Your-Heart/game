//
//  TextureLiteralMacroTests.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 6/11/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftGodotMacroLibrary

final class TextureLiteralMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "texture2DLiteral": Texture2DLiteralMacro.self
    ]

    func testMacroExpansion() {
        assertMacroExpansion(
            """
            let spriteTexture = #texture2DLiteral("res://assets/icon.png")
            """,
            expandedSource: """
            let spriteTexture = {
                guard let texture: Texture2D = GD.load(path: "res://assets/icon.png") else {
                    preconditionFailure(
                        "Texture could not be loaded.",
                        file: "TestModule/test.swift",
                        line: 1)
                }
                return texture
            }()
            """,
            macros: testMacros
        )
    }

    func testMacroExpansionFailure() {
        assertMacroExpansion(
            """
            let spriteTexture = #texture2DLiteral()
            """,
            expandedSource: """
            let spriteTexture = ""
            """,
            diagnostics: [
                .init(message: "Argument 'path' is missing.", line: 1, column: 21)
            ],
            macros: testMacros
        )
    }
}
