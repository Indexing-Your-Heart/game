//
//  RollinsportWorld2D.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 29/10/23.
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
class RollinsportWorld2D: Node2D {
    @SceneTree(path: "CanvasLayer/Reader") var reader: JensonTimeline?

    required init() {
        Self.initializeClass()
        super.init()
    }

    override func _ready() {
        super._ready()

        do {
            try reader?.connect(signal: "timeline_finished", callable: #methodName(timelineFinished))
        } catch {
            LibRollinsport.logger.error("Failed to connect to reader's end signal: \(error.localizedDescription)")
        }
    }

    @Callable func timelineFinished() {
        guard let reader else {
            LibRollinsport.logger.error("Timeline finished receiver called with no target.")
            return
        }
        reader.hide()
    }
}

extension RollinsportWorld2D {
    static func initializeClass() {
        let className = StringName("\(RollinsportWorld2D.self)")
        let classInfo = ClassInfo<RollinsportWorld2D>(name: className)

        classInfo.registerMethod(name: "_callable_timelineFinished",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: RollinsportWorld2D._callable_timelineFinished)
    }
}
