//
//  SceneTreeMacroTests.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 21/6/23.
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

final class SceneTreeMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "SceneTree": SceneTreeMacro.self
    ]

    func testMacroExpansion() {
        assertMacroExpansion(
            """
            class MyNode: Node {
                @SceneTree(path: "Entities/CharacterBody2D")
                var character: CharacterBody2D?
            }
            """,
            expandedSource: """
            class MyNode: Node {
                var character: CharacterBody2D? {
                    get {
                        getNodeOrNull(NodePath("Entities/CharacterBody2D")) as? CharacterBody2D
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroMissingPathDiagnostic() {
        assertMacroExpansion(
            """
            class MyNode: Node {
                @SceneTree
                var character: CharacterBody2D?
            }
            """,
            expandedSource: """
            class MyNode: Node {
                var character: CharacterBody2D?
            }
            """,
            diagnostics: [
                .init(message: "Missing argument 'path'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroMissingTypeAnnotationDiagnostic() {
        assertMacroExpansion(
            """
            class MyNode: Node {
                @SceneTree(path: "Entities/CharacterBody2D")
                var character
            }
            """,
            expandedSource: """
            class MyNode: Node {
                var character
            }
            """,
            diagnostics: [
                .init(message: "SceneTree requires an explicit type declaration", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroNotOptionalDiagnostic() {
        assertMacroExpansion(
            """
            class MyNode: Node {
                @SceneTree(path: "Entities/CharacterBody2D")
                var character: CharacterBody2D
            }
            """,
            expandedSource: """
            class MyNode: Node {
                var character: CharacterBody2D
            }
            """,
            diagnostics: [
                .init(message: "Stored properties with SceneTree must be marked as Optional",
                      line: 1,
                      column: 1,
                      fixIts: [
                        .init(message: "Mark as Optional")
                      ])
            ],
            macros: testMacros
        )
    }
}
