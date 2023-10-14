//
//  LibRollinsport.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/09/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Logging
import SwiftGodot

@GodotMain
class LibRollinsport: GodotExtensionDelegate {
    static var logger = Logger(label: "godotengine.swiftgodot.rollinsport")

    var allNodeTypes: [Wrapped.Type] = [
        NumberPuzzleNode.self
    ]

    func extensionWillInitialize() {
        LoggingSystem.bootstrap(GodotLogger.init)
    }

    func extensionDidInitialize(at _: GDExtension.InitializationLevel) {
        for type in allNodeTypes {
            register(type: type)
        }
    }
}
