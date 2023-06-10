//
//  NativeHandleDiscardingMacro.swift
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

public struct NativeHandleDiscardingMacro: MemberMacro {
    enum ProviderDiagnostic: String, DiagnosticMessage {
        case notAClass
        case missingNode
        var severity: DiagnosticSeverity {
            switch self {
            case .notAClass: return .error
            case .missingNode: return .error
            }
        }

        var message: String {
            switch self {
            case .notAClass:
                return "@NativeHandleDiscarding can only be applied to a 'class'"
            case .missingNode:
                return "@NativeHandleDiscarding requires inheritance to 'Node' or a subclass"
            }
        }

        var diagnosticID: MessageID {
            MessageID(domain: "SwiftGodotMacros", id: rawValue)
        }
    }

    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context) throws -> [DeclSyntax] {
            guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
                let classError = Diagnostic(node: declaration.root, message: ProviderDiagnostic.notAClass)
                context.diagnose(classError)
                return []
            }

            let initSyntax = try InitializerDeclSyntax("required init(nativeHandle _: UnsafeRawPointer)") {
                StmtSyntax("fatalError(\"init(nativeHandle:) has not been implemented\")")
            }

            return [DeclSyntax(initSyntax)]
    }
}
