//
//  SwiftGodotMacros.swift
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

/// A macro that enables an enumeration to be visible to the Godot editor.
///
/// Use this macro with `ClassInfo.registerEnum` to register this enumeration's visibility in the Godot editor.
///
/// - Important: The enumeration should have an `Int` backing to allow being represented as an integer value by Godot.
@attached(conformance)
@attached(member, names: named(name))
public macro PickerNameProvider() = #externalMacro(module: "SwiftGodotMacrosMacros", type: "PickerNameProviderMacro")


/// A macro that automatically implements `init(nativeHandle:)` for nodes.
@attached(member, names: named(init(nativeHandle:)))
public macro NativeHandleDiscarding() = #externalMacro(module: "SwiftGodotMacrosMacros", type: "NativeHandleDiscardingMacro")
