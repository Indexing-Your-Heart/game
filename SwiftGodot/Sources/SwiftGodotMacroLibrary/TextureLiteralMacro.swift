//
//  TextureLiteralMacro.swift
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

import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Texture2DLiteralMacro: ExpressionMacro {
    enum ProviderDiagnostic: String, DiagnosticMessage {
        case missingArguments
        var severity: DiagnosticSeverity {
            switch self {
            case .missingArguments: return .error
            }
        }

        var message: String {
            switch self {
            case .missingArguments:
                return "Argument 'path' is missing."
            }
        }

        var diagnosticID: MessageID {
            MessageID(domain: "SwiftGodotMacros", id: rawValue)
        }
    }

    public static func expansion(of node: some FreestandingMacroExpansionSyntax,
                                 in context: some MacroExpansionContext) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            let argumentError = Diagnostic(node: node.root, message: ProviderDiagnostic.missingArguments)
            context.diagnose(argumentError)
            return "<#placeholder#>"
        }
        let location: AbstractSourceLocation = context.location(of: node)!
        return """
        {
            guard let texture: Texture2D = GD.load(path: \(argument)) else {
                preconditionFailure(
                    "Texture could not be loaded.",
                    file: \(raw: location.file),
                    line: \(raw: location.line))
            }
            return texture
        }()
        """
    }
}
