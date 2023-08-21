//
//  SwiftGodotNamePickerMacroTests.swift
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

final class PickerNameProviderMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "PickerNameProvider": PickerNameProviderMacro.self
    ]
    
    func testPickerNameProviderMacro() {
        assertMacroExpansion(
            """
            @PickerNameProvider
            enum Character: Int {
                case chelsea
                case sky
            }
            """,
            expandedSource: """

            enum Character: Int {
                case chelsea
                case sky
            }

            extension Character: CaseIterable {
            }
            
            extension Character: Nameable {
                var name: String {
                    switch self {
                    case .chelsea:
                        return "Chelsea"
                    case .sky:
                        return "Sky"
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testPickerNameProviderMacroDiagnostics() {
        assertMacroExpansion(
            """
            @PickerNameProvider
            struct Character {
            }
            """,
            expandedSource: """

            struct Character {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@PickerNameProvider can only be applied to an 'enum'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            """
            @PickerNameProvider
            enum Character {
                case chelsea
                case sky
            }
            """,
            expandedSource: """

            enum Character {
                case chelsea
                case sky
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@PickerNameProvider requires an Int backing", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
