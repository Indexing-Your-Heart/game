//
//  SwiftGodotInitSwiftExtensionMacroTests.swift
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

final class InitSwiftExtensionMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "initSwiftExtension": InitSwiftExtensionMacro.self
    ]

    func testInitSwiftExtensionMacro() {
        assertMacroExpansion(
            """
            #initSwiftExtension(cdecl: "libchrysalis_entry_point", types: [ChrysalisNode.self])
            """,
            expandedSource: """
            @_cdecl("libchrysalis_entry_point") public func enterExtension(interface: OpaquePointer?, library: OpaquePointer?, extension: OpaquePointer?) -> UInt8 {
                guard let library, let interface, let `extension` else {
                    print("Error: Not all parameters were initialized.")
                    return 0
                }
                let deinitHook: (GDExtension.InitializationLevel) -> Void = { _ in
                }
                initializeSwiftModule(interface, library, `extension`, initHook: setupExtension, deInitHook: deinitHook)
                return 1
            }
            func setupExtension(level: GDExtension.InitializationLevel) {
                let types = [ChrysalisNode.self]
                switch level {
                case .scene:
                    types.forEach(register)
                default:
                    break
                }
            }
            """,
            macros: testMacros
        )
    }
}
