//
//  LibDemoscene.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/04/23.
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
class LibDemoscene: GodotExtensionDelegate {
    static var logger = Logger(label: "godotengine.swiftgodot.libdemoscene")

    var allNodes: [Wrapped.Type] = [
        DemoBaseNode.self,
        DemoBaseControl.self,
        DemoJensonTimeline.self,
        DemoAshashatKeyboard.self,
        DemoAshashatNumpad.self,
        DemosceneUI.self
    ]

    func extensionWillInitialize() {
        LoggingSystem.bootstrap(GodotLogger.init)
    }

    func extensionDidInitialize(at level: GDExtension.InitializationLevel) {
        switch level {
        case .scene:
            for nodeType in allNodes {
                register(type: nodeType)
            }
        default:
            break
        }
    }

    func extensionWillDeinitialize(at _: GDExtension.InitializationLevel) {}
}
