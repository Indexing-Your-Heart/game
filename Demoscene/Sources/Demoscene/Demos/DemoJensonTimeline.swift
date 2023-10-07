//
//  DemoJensonTimeline.swift
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

import JensonGodotKit
import SwiftGodot

@NativeHandleDiscarding
class DemoJensonTimeline: DemoBaseControl {
    @SceneTree(path: "JensonTimeline") var timeline: JensonTimeline?

    required init() {
        DemoJensonTimeline.initClass
        super.init()
    }

    override func _ready() {
        super._ready()
        timeline?.connect(signal: "timeline_finished", callable: #methodName(timelineFinished))
    }

    @Callable func timelineFinished() {
        LibDemoscene.logger.debug("Timeline finished. Sending back to demo menu.")
        getTree()?.changeSceneToFile(path: "res://demos/demo_menu.tscn")
    }
}

extension DemoJensonTimeline {
    static var initClass: Void = {
        let className = StringName(stringLiteral: "\(DemoJensonTimeline.self)")
        let classInfo = ClassInfo<DemoJensonTimeline>(name: className)

        classInfo.registerMethod(name: "_callable_timelineFinished",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: DemoJensonTimeline._callable_timelineFinished)
    }()
}
