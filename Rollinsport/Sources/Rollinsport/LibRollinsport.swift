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
        NumberPuzzleNode.self,
        WordPuzzleNode.self,
        RollinsportWorld2D.self,

        // Register the singleton types as well, so Godot's aware of what they are.
        // As to why this can't be done with registering the singleton itself is beyond me.
        WorldDataObserver.self,
        RollinsportMessageBus.self
    ]

    func extensionWillInitialize() {
        LoggingSystem.bootstrap(GodotLogger.init)
    }

    func extensionDidInitialize(at level: GDExtension.InitializationLevel) {
        guard level == .scene else { return }
        for type in allNodeTypes {
            register(type: type)
        }
        Engine.registerSingleton(name: StringName("\(WorldDataObserver.self)"),
                                 instance: WorldDataObserver.shared)
        Engine.registerSingleton(name: StringName("\(RollinsportMessageBus.self)"),
                                 instance: RollinsportMessageBus.shared)
    }
}
