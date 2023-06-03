//
//  JensonTimeline.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/30/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import JensonKit
import SwiftGodot

public class JensonTimeline: Node {
    public var script: String?

    private var animator: AnimationPlayer?
    private var currentEvent: JensonEvent?
    private var reader: JensonReader?
    private var timeline = [JensonEvent]()
    private var whoLabel: Label?
    private var whatLabel: Label?

    public required init() {
        JensonTimeline.initClass
        super.init()
    }

    public override func _ready() {
        super._ready()
        animator = getNode(path: NodePath(stringLiteral: "AnimationPlayer")) as? AnimationPlayer
        whoLabel = findChild(pattern: "Who Label", recursive: true) as? Label
        whatLabel = findChild(pattern: "What Label", recursive: true) as? Label

        guard !Engine.shared.isEditorHint() else { return }
        whoLabel?.text = ""
        whatLabel?.text = ""
        if let animator {
            animator.play(name: StringName("start_timeline"))
        } else {
            GD.print("Couldn't get the animation")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.next()
        }
    }

    public override func _input(event: InputEvent) {
        if event.isActionPressed(action: "timeline_next") || Input.shared.isMouseButtonPressed(button: .left) {
            next()
        }
    }

    @available(*, unavailable)
    required init(nativeHandle: UnsafeRawPointer) {
        fatalError("init(nativeHandle:) has not been implemented")
    }

    func loadScript() {
        do {
            let reader = try JensonReader(resource: script ?? "")
            guard let file = try reader?.decode() else {
                GD.pushError("Decoded file for \(script) returned nil.")
                return
            }
            timeline = file.timeline.filter { event in event.type != .comment }
            if timeline.isEmpty {
                GD.pushWarning("The file loaded, but the timeline is empty.")
                return
            }
        } catch {
            GD.pushError("Failed to load reader for script", error.localizedDescription)
        }
    }

    func next() {
        guard !timeline.isEmpty else {
            GD.pushWarning("Attempted to move to an empty slot.")
            return
        }
        currentEvent = timeline.removeFirst()
        if let currentEvent {
            setup(event: currentEvent)
        }
    }

    func setup(event: JensonEvent) {
        switch event.type {
        case .dialogue:
            GD.print(event, whoLabel, whoLabel)
            whoLabel?.text = event.who
            whatLabel?.text = event.what
            animator?.play(name: StringName("speech"))
        default:
            GD.pushWarning("Unknown event type: \(event.type.rawValue). This will be skipped.")
            next()
        }
    }
}
