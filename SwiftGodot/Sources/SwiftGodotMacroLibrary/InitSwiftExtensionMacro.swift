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

        let name = cDecl.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text ?? "libentry"

        let initModule = try FunctionDeclSyntax(
            "@_cdecl(\(raw: cDecl.description)) public func \(raw: name)(interface: OpaquePointer?, library: OpaquePointer?, extension: OpaquePointer?) -> UInt8") {
                try GuardStmtSyntax("guard let library, let interface, let `extension` else") {
                    StmtSyntax(stringLiteral: #"print("Error: Not all parameters were initialized.")"#)
                    StmtSyntax(stringLiteral: "return 0")
                }
                StmtSyntax(stringLiteral: "initializeSwiftModule(interface, library, `extension`, initHook: setupExtension, deInitHook: { _ in })")
                StmtSyntax(stringLiteral: "return 1")
        }

        let setupModule = try FunctionDeclSyntax("func setupExtension(level: GDExtension.InitializationLevel)") {
            StmtSyntax(stringLiteral: "let types = \(types)")
            try SwitchExprSyntax("switch level") {
                SwitchCaseSyntax("case .scene:") {
                    StmtSyntax(stringLiteral: "types.forEach(register)")
                }
                SwitchCaseSyntax("default:") {
                    StmtSyntax(stringLiteral: "break")
                }
            }
        }

        return [DeclSyntax(initModule), DeclSyntax(setupModule)]
    }
}
