//
//  PickerNameProviderMacro.swift
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

import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PickerNameProviderMacro: MemberMacro {
    enum ProviderDiagnostic: String, DiagnosticMessage {
        case notAnEnum
        case missingInt
        var severity: DiagnosticSeverity {
            switch self {
            case .notAnEnum: return .error
            case .missingInt: return .error
            }
        }

        var message: String {
            switch self {
            case .notAnEnum:
                return "@PickerNameProvider can only be applied to an 'enum'"
            case .missingInt:
                return "@PickerNameProvider requires an Int backing"
            }
        }

        var diagnosticID: MessageID {
            MessageID(domain: "SwiftGodotMacros", id: rawValue)
        }
    }

    public static func expansion(of node: AttributeSyntax,
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
            guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
                let enumError = Diagnostic(node: declaration.root, message: ProviderDiagnostic.notAnEnum)
                context.diagnose(enumError)
                return []
            }

            guard let inheritors = enumDecl.inheritanceClause?.inheritedTypeCollection else {
                let missingInt = Diagnostic(node: declaration.root, message: ProviderDiagnostic.missingInt)
                context.diagnose(missingInt)
                return []
            }

            let types = inheritors.map { $0.typeName.as(SimpleTypeIdentifierSyntax.self) }
            let names = types.map { $0?.name.text }

            guard names.contains("Int") else {
                let missingInt = Diagnostic(node: declaration.root, message: ProviderDiagnostic.missingInt)
                context.diagnose(missingInt)
                return []
            }

            let members = enumDecl.memberBlock.members
            let cases = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            let elements = cases.flatMap { $0.elements }

            let nameDeclBase = try VariableDeclSyntax("var name: String") {
                try SwitchExprSyntax("switch self") {
                    for element in elements {
                        SwitchCaseSyntax(
                            """
                            case .\(element.identifier):
                                return \(literal: element.identifier.text.capitalized)
                            """
                        )
                    }
                }
            }

            var nameDecl = nameDeclBase
            if let modifiers = enumDecl.modifiers {
                for modifier in modifiers {
                    nameDecl = nameDecl.addModifier(modifier)
                }
            }

            return [DeclSyntax(nameDecl)]
        }
}

extension PickerNameProviderMacro: ConformanceMacro {
    public typealias ConformanceInformation = (SwiftSyntax.TypeSyntax, SwiftSyntax.GenericWhereClauseSyntax?)
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 providingConformancesOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [ConformanceInformation] {
            return [("CaseIterable", nil), ("Nameable", nil)]
        }
}