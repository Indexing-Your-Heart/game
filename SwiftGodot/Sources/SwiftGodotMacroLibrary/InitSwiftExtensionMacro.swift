//
//  InitSwiftExtensionMacro.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/27/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InitSwiftExtensionMacro: DeclarationMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax,
                                 in context: some MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {

        guard let cDecl = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        guard let types = node.argumentList.last?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        let initModule: DeclSyntax = """
        @_cdecl(\(raw: cDecl.description)) public func enterExtension(interface: OpaquePointer?, library: OpaquePointer?, extension: OpaquePointer?) -> UInt8 {
            guard let library, let interface, let `extension` else {
                print("Error: Not all parameters were initialized.")
                return 0
            }
            let deinitHook: (GDExtension.InitializationLevel) -> Void = { _ in }
            initializeSwiftModule(interface, library, `extension`, initHook: setupExtension, deInitHook: deinitHook)
            return 1
        }
        """

        let setupModule: DeclSyntax = """
        func setupExtension(level: GDExtension.InitializationLevel) {
            let types = \(types)
            switch level {
            case .scene:
                types.forEach(register)
            default:
                break
            }
        }
        """
        return [initModule, setupModule]
    }
}
