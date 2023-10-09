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

import SwiftGodot

@NativeHandleDiscarding
public class AnthroCharacterBody2D: CharacterBody2D {
    @PickerNameProvider
    public enum Character: Int {
        case chelsea
        case obel
    }

    enum PlayerState: Equatable {
        case idle
        case walking
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

    var currentState = PlayerState.idle

    private var movementVector: Vector2 {
        Input.getVector(negativeX: "move_left",
                        positiveX: "move_right",
                        negativeY: "move_up",
                        positiveY: "move_down")
        .normalized()
    }

    public required init() {
        AnthroCharacterBody2D.initializeClass()
        friction = 100
        speed = 200
        acceleration = 250
        super.init()
    }

    override public func _ready() {
        super._ready()
        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
        LibAnthrobase.logger.debug("Animation state is: \(String(describing: animationState))")
    }

    override public func _physicsProcess(delta: Double) {
        if Engine.isEditorHint() { return }
        if movementVector != Vector2.zero {
            currentState = .walking
            updateBlendingProperties(with: movementVector)
            velocity = (movementVector * Vector2(x: acceleration, y: acceleration)).limitLength(length: speed)
        } else {
            currentState = .idle
            velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        updateAnimationContditions()
        _ = moveAndSlide()
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

    private func updateAnimationContditions() {
        animationTree?.set(property: "parameters/conditions/idling",
                           value: (currentState == .idle).toVariant())
        animationTree?.set(property: "parameters/conditions/walking",
                           value: (currentState == .walking).toVariant())
    }
}
