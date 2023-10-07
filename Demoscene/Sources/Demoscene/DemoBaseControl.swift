//
//  DemoBaseControl.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/07/23.
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

@NativeHandleDiscarding
class DemoBaseControl: Control {
    required init() {
        super.init()
    }

    override func _unhandledInput(event: InputEvent?) {
        if Input.isActionPressed(action: "cancel") {
            LibDemoscene.logger.info("Received message to return to menu.")
            _ = getTree()?.changeSceneToFile(path: "res://demos/demo_menu.tscn")
        }
        super._unhandledInput(event: event)
    }
}

@NativeHandleDiscarding
class DemoBaseNode: Node {
    required init() {
        super.init()
    }

    override func _unhandledInput(event: InputEvent?) {
        if Input.isActionPressed(action: "cancel") {
            LibDemoscene.logger.info("Received message to return to menu.")
            _ = getTree()?.changeSceneToFile(path: "res://demos/demo_menu.tscn")
        }
        super._unhandledInput(event: event)
    }
}
