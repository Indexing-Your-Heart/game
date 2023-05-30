//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/27/23.
//

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
        self.friction = 100
        self.speed = 200
        self.acceleration = 250
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
        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
    }

    public override func _physicsProcess(delta: Double) {
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
