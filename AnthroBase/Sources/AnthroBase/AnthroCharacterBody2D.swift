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
        Vector2(
            x: Float(Input().getActionStrength(action: "move_right") - Input().getActionStrength(action: "move_left")),
            y: Float(Input().getActionStrength(action: "move_down") - Input().getActionStrength(action: "move_up")))
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
        sprite = getNode(path: "Sprite") as? Sprite2D
        animationTree = getNode(path: "Sprite/AnimationTree") as? AnimationTree
        animationPlayer = getNode(path: "Sprite/AnimationPlayer") as? AnimationPlayer
        animationState = animationTree?.get(property: "parameters/playback") as? AnimationNodeStateMachinePlayback
    }

    public override func _physicsProcess(delta _: Double) {
        if movementVector != Vector2.zero {
            updateBlendingProperties(with: movementVector)
            animationState?.travel(toNode: StringName("Walk"))
            velocity = (velocity * movementVector * Vector2(x: acceleration, y: acceleration))
                .limitLength(length: speed)
        } else {
            animationState?.travel(toNode: StringName("Idle"))
            velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        moveAndSlide()
    }


    private func updateBlendingProperties(with vector: Vector2) {
        guard let animationTree else { return }
        animationTree.set(property: StringName("parameters/Idle/blend_position"), value: vector.toVariant())
        animationTree.set(property: StringName("parameters/Walk/blend_position"), value: vector.toVariant())
    }
}
