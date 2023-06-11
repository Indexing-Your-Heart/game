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

import SwiftGodot

/// A macro used to write an entrypoint for a Godot extension.
///
/// For example, to initialize a Swift extension to Godot with custom types:
/// ```swift
/// class MySprite: Sprite2D { ... }
/// class MyControl: Control { ... }
///
/// #initSwiftExtension(cdecl: "myextension_entry_point",
///                     types: [MySprite.self, MyControl.self])
/// ```
///
/// - Parameter cdecl: The name of the entrypoint exposed to C.
/// - Parameter types: The node types that should be registered with Godot.
@freestanding(declaration)
public macro initSwiftExtension<T: Wrapped>(cdecl: String, types: [T.Type]) = #externalMacro(module: "SwiftGodotMacrosMacros", type: "InitSwiftExtensionMacro")

/// A macro that enables an enumeration to be visible to the Godot editor.
///
/// Use this macro with `ClassInfo.registerEnum` to register this enumeration's visibility in the Godot editor.
///
/// ```swift
/// @PickerNameProvider
/// enum PlayerClass: Int {
///     case barbarian
///     case mage
///     case wizard
/// }
/// ```
///
/// - Important: The enumeration should have an `Int` backing to allow being represented as an integer value by Godot.
@attached(conformance)
@attached(member, names: named(name))
public macro PickerNameProvider() = #externalMacro(module: "SwiftGodotMacrosMacros", type: "PickerNameProviderMacro")


/// A macro that automatically implements `init(nativeHandle:)` for nodes.
@attached(member, names: named(init(nativeHandle:)))
public macro NativeHandleDiscarding() = #externalMacro(module: "SwiftGodotMacrosMacros", type: "NativeHandleDiscardingMacro")
