//
//  DemosceneUI.swift
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

import SwiftGodot

@NativeHandleDiscarding
class DemosceneUI: Window {
    @SceneTree(path: "Container/VBoxContainer/EnvironmentDemo")
    var buttonEnvironment: Button?

    @SceneTree(path: "Container/VBoxContainer/ProtractorDemo")
    var buttonProtractor: Button?

    @SceneTree(path: "Container/VBoxContainer/JensonDemo")
    var buttonJenson: Button?

    @SceneTree(path: "Container/VBoxContainer/AshashatDemo")
    var buttonAshashat: Button?

    @SceneTree(path: "Container/VBoxContainer/AshashatNumpadDemo")
    var buttonAshashatNumpad: Button?

    private lazy var mapping: [String: Button?] = {
        [
            "environment_demo": buttonEnvironment,
            "protractor_demo": buttonProtractor,
            "jenson_demo": buttonJenson,
            "ashahsat_demo": buttonAshashat,
            "ashahsat_numbers_demo": buttonAshashatNumpad
        ]
    }()

    required init() {
        super.init()
    }

    override func _ready() {
        super._ready()

        for (demoName, button) in mapping {
            button?.pressed.connect { [weak self] in
                self?.switchToDemo(named: demoName)
            }
        }
    }

    private func switchToDemo(named demo: String) {
        LibDemoscene.logger.debug("Received message to open demo: \(demo)")
        getTree()?.changeSceneToFile(path: "res://demos/\(demo).tscn")
    }
}
