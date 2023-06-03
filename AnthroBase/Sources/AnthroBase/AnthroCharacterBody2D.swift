//
//  AnthroCharacterBody2D.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/27/23.
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
import SwiftGodot

public class AnthroCharacterBody2D: CharacterBody2D {
    public enum Character: Int, CaseIterable, Nameable {
        case chelsea
        case sky

        public var name: String {
            switch self {
            case .chelsea:
                return "Chelsea"
            case .sky:
                return "Sky"
            }
        }
    }

    var sprite: Sprite2D?
    var animationTree: AnimationTree?
    var animationPlayer: AnimationPlayer?
    var animationState: AnimationNodeStateMachinePlayback?

    public var acceleration: Float
    public var character: Character = .chelsea
    public var friction: Double
    public var speed: Double

    private var movementVector: Vector2 {
        Input.shared.getVector(negativeX: "move_left",
                               positiveX: "move_right",
                               negativeY: "move_up",
                               positiveY: "move_down")
            .normalized()
    }

    public required init() {
        AnthroCharacterBody2D.initClass
        friction = 100
        speed = 200
        acceleration = 250
        super.init()
    }

    @available(*, unavailable)
    required init(nativeHandle _: UnsafeRawPointer) {
        fatalError("init(nativeHandle:) has not been implemented")
    }

    override public func _ready() {
        super._ready()
        sprite = getNodeOrNull(path: NodePath(stringLiteral: "Sprite")) as? Sprite2D
        animationTree = getNodeOrNull(path: NodePath(stringLiteral: "Sprite/AnimationTree")) as? AnimationTree
        animationPlayer = getNodeOrNull(path: NodePath(stringLiteral: "Sprite/AnimationPlayer")) as? AnimationPlayer
        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
    }

    override public func _physicsProcess(delta: Double) {
        if Engine.shared.isEditorHint() { return }
        if movementVector != Vector2.zero {
            updateBlendingProperties(with: movementVector)
            animationState?.travel(toNode: StringName("Walk"), resetOnTeleport: false)
            velocity = (movementVector * Vector2(x: acceleration, y: acceleration)).limitLength(length: speed)
        } else {
            animationState?.travel(toNode: StringName("Idle"), resetOnTeleport: false)
            velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        moveAndSlide()
        super._physicsProcess(delta: delta)
    }

    private func updateBlendingProperties(with vector: Vector2) {
        guard let animationTree else {
            GD.pushError("Animation tree is missing.")
            return
        }

        // FIXME: This seems to do nothing. Why?
        animationTree.set(property: StringName("parameters/Idle/blend_position"), value: Variant(vector))
        animationTree.set(property: StringName("parameters/Walk/blend_position"), value: Variant(vector))
    }
}
