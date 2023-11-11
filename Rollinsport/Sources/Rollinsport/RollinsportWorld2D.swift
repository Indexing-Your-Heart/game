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

import AnthroBase
import JensonGodotKit
import SwiftGodot

@NativeHandleDiscarding
class RollinsportWorld2D: Node2D {
    @SceneTree(path: "Player") var player: AnthroCharacterBody2D?
    @SceneTree(path: "CanvasLayer/Reader") var reader: JensonTimeline?
    @SceneTree(path: "CanvasLayer/Overlay") var overlay: ColorRect?

    required init() {
        Self.initializeClass()
        super.init()
    }

    override func _ready() {
        super._ready()

        guard !Engine.isEditorHint() else { return }
        do {
            try reader?.connect(signal: "timeline_finished", callable: #methodName(timelineFinished))
        } catch {
            LibRollinsport.logger.error("Failed to connect to reader's end signal: \(error.localizedDescription)")
        }

        do {
            try RollinsportMessageBus.shared.registerSubscriber(#methodName(puzzleSolved), to: .puzzleSolved(id: ""))
        } catch {
            LibRollinsport.logger.error("Failed to subscribe to message bus: \(error.localizedDescription)")
        }

        WorldDataObserver.shared.loadData(into: self)
    }

    @Callable func timelineFinished() {
        guard let reader else {
            LibRollinsport.logger.error("Timeline finished receiver called with no target.")
            return
        }
        reader.hide()
        hideOverlayIfPresent()
    }

    func hideOverlayIfPresent() {
        guard let overlay, let tween = getTree()?.createTween(), overlay.color.alpha > 0 else { return }
        _ = tween.tweenProperty(object: overlay,
                                property: "color",
                                finalVal: Color.transparent.toVariant(),
                                duration: 0.5)
    }

    // TODO: Test, Test, Test!
    func displayJensonScript(named scriptName: String) {
        guard let overlay, let tween = getTree()?.createTween() else { return }
        _ = tween.tweenProperty(object: overlay, property: "color", finalVal: Color.black.toVariant(), duration: 1.5)
        reader?.script = "res://data/\(scriptName).jenson"
    }

    @Callable func puzzleSolved(id: String) {
        guard let player else { return }
        let codablePosition = WorldDataBlob.Position(vector2: player.globalPosition)
        WorldDataObserver.shared.saveData(blob: .init(playerPosition: codablePosition))
    }
}

extension RollinsportWorld2D {
    static func initializeClass() {
        let className = StringName("\(RollinsportWorld2D.self)")
        let classInfo = ClassInfo<RollinsportWorld2D>(name: className)

        let solvedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: "puzzle_id",
                     className: className,
                     hint: .typeString,
                     hintStr: "",
                     usage: .default)
        ]

        classInfo.registerMethod(name: "_callable_timelineFinished",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: RollinsportWorld2D._callable_timelineFinished)
        classInfo.registerMethod(name: "_callable_puzzleSolved",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: solvedSignalProps,
                                 function: RollinsportWorld2D._callable_puzzleSolved)
    }
}