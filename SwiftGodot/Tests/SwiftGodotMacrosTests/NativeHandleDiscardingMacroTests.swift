//
//  SwiftGodotNativeHandleDiscardingMacroTests.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 6/9/23.
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

final class NativeHandleDiscardingMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "NativeHandleDiscarding": NativeHandleDiscardingMacro.self
    ]

    func testNativeHandleDiscardingMacro() {
        assertMacroExpansion(
            """
            @NativeHandleDiscarding
            class MyNode: Sprite2D {
                var collider: CollisionShape2D?
            }
            """,
            expandedSource: """

            class MyNode: Sprite2D {
                var collider: CollisionShape2D?

                required init(nativeHandle _: UnsafeRawPointer) {fatalError("init(nativeHandle:) has not been implemented")
                }
            }
            """,
            macros: testMacros
        )
    }

    func testNativeHandleDiscardingMacroDiagnostics() {
        assertMacroExpansion(
            """
            @NativeHandleDiscarding
            struct MyNode: Sprite2D {
                var collider: CollisionShape2D?
            }
            """,
            expandedSource: """
            
            struct MyNode: Sprite2D {
                var collider: CollisionShape2D?
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@NativeHandleDiscarding can only be applied to a 'class'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
