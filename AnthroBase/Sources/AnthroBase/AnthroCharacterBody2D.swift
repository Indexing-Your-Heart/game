//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/27/23.
//

import Foundation
import SwiftGodot

public class AnthroCharacterBody2D: CharacterBody2D {
    var sprite: Sprite2D?
    var animationTree: AnimationTree?
    var animationPlayer: AnimationPlayer?
    var animationState: AnimationNodeStateMachinePlayback?

    public var friction: Double
    public var speed: Double

    private var movementVector: Vector2 {
        Input.shared.getVector(negativeX: "move_left",
                               positiveX: "move_right",
                               negativeY: "move_up",
                               positiveY: "move_down")
        .normalized()
    }
 
    private let acceleration: Float = 250

    public required init() {
        self.friction = 100
        self.speed = 200
        super.init()
    }

    @available(*, unavailable)
    required init(nativeHandle: UnsafeRawPointer) {
        fatalError("init(nativeHandle:) has not been implemented")
    }

    public override func _ready() {
        super._ready()
        sprite = getNodeOrNull(path: NodePath(stringLiteral: "Sprite")) as? Sprite2D
        animationTree = getNodeOrNull(path: NodePath(stringLiteral: "Sprite/AnimationTree")) as? AnimationTree
        animationPlayer = getNodeOrNull(path: NodePath(stringLiteral: "Sprite/AnimationPlayer")) as? AnimationPlayer
        // FIXME: This causes a crash. Why?
//        animationState = animationTree?.get(property: StringName("parameters/playback")) as? AnimationNodeStateMachinePlayback
    }

    public override func _physicsProcess(delta: Double) {
        if Engine.shared.isEditorHint() { return }
        if movementVector != Vector2.zero {
            updateBlendingProperties(with: movementVector)
            animationState?.travel(toNode: StringName("Walk"))
            velocity = (movementVector * Vector2(x: acceleration, y: acceleration)).limitLength(length: speed)
        } else {
            animationState?.travel(toNode: StringName("Idle"))
            velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        moveAndSlide()
        super._physicsProcess(delta: delta)
    }


    private func updateBlendingProperties(with vector: Vector2) {
        guard let animationTree else { return }
        animationTree.set(property: StringName("parameters/Idle/blend_position"), value: vector.toVariant())
        animationTree.set(property: StringName("parameters/Walk/blend_position"), value: vector.toVariant())
    }
}
