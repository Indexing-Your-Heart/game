//
//  JensonGodotKit.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/29/23.
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
import JensonKit

/// The public entry point for the GDExtension.
@_cdecl("libjensongodotkit_entry_point")
public func libjensongodotkit_entry_point(interface: OpaquePointer?,
                                          library: OpaquePointer?,
                                          extension: OpaquePointer?) -> UInt8
{
    guard let library, let interface, let `extension` else {
        print("Error: Not all parameters were initialized.")
        print("Library:", library, "Interface", interface, "Extension", `extension`)
        return 0
    }
    initializeSwiftModule(interface, library, `extension`, initHook: setupExtension, deInitHook: { _ in })
    return 1
}

func setupExtension(at level: GDExtension.InitializationLevel) {
    switch level {
    case .scene:
        register(type: JensonTimeline.self)
    default:
        break
    }
}
