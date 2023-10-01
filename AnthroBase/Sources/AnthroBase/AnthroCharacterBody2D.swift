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
import SwiftGodotMacros

@NativeHandleDiscarding
public class AnthroCharacterBody2D: CharacterBody2D {
    @PickerNameProvider
    public enum Character: Int {
        case chelsea
        case obel
    }

    @SceneTree(path: "Sprite")
    var sprite: Sprite2D?

    @SceneTree(path: "Sprite/AnimationTree")
    var animationTree: AnimationTree?

    @SceneTree(path: "Sprite/AnimationPlayer")
    var animationPlayer: AnimationPlayer?
    var animationState: AnimationNodeStateMachinePlayback?

    public var acceleration: Float
    public var character: Character = .chelsea
    public var friction: Double
    public var speed: Double

    private var movementVector: Vector2 {
        Input.getVector(negativeX: "move_left",
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

    override public func _ready() {
        super._ready()
        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
    }

    override public func _physicsProcess(delta: Double) {
        if Engine.isEditorHint() { return }
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

    func changeSprites() {
        switch character {
        case .chelsea:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_chelsea.png")
        case .obel:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_obel.png")
        }
    }

    private func updateBlendingProperties(with vector: Vector2) {
        guard let animationTree else {
            GD.pushError("Animation tree is missing.")
            return
        }

        animationTree.set(property: StringName("parameters/Idle/blend_position"), value: Variant(vector))
        animationTree.set(property: StringName("parameters/Walk/blend_position"), value: Variant(vector))
    }
}
