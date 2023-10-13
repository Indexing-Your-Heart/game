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
        case navigating // used for navigation
    }

    public var acceleration: Float
    public var character: Character = .chelsea
    public var friction: Double
    public var speed: Double

    @SceneTree(path: "Camera") var camera: Camera2D?
    @SceneTree(path: "Sprite/AnimationTree") var animationTree: AnimationTree?
    @SceneTree(path: "Sprite/AnimationPlayer") var animationPlayer: AnimationPlayer?
    @SceneTree(path: "Navigator") var navigator: NavigationAgent2D?
    @SceneTree(path: "Sprite") var sprite: Sprite2D?

    var animationState: AnimationNodeStateMachinePlayback?
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

    public override func _ready() {
        super._ready()
        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
        LibAnthrobase.logger.debug("Animation state is: \(String(describing: animationState))")

        navigator?.pathDesiredDistance = 4
        navigator?.targetDesiredDistance = 4
    }

    public override func _unhandledInput(event: InputEvent?) {
        super._unhandledInput(event: event)
        guard let event else { return }

        if event.isClass("\(InputEventScreenTouch.self)"), event.isPressed() {
            var newPosition = Vector2(event.get(property: "position")) ?? .zero
            if let transform = getViewport()?.canvasTransform {
                newPosition = newPosition * transform
            }

            getTree()?.physicsFrame.connect { [weak self] in
                _ = self?.callDeferred(method: "move_toward", newPosition.toVariant())
            }
        }
    }

    public override func _physicsProcess(delta: Double) {
        super._physicsProcess(delta: delta)
        if Engine.isEditorHint() { return }
        if currentState == .navigating {
            navigateToNextTarget()
            updateAnimationConditions()
            return
        }

        if movementVector != Vector2.zero {
            currentState = .walking
            updateBlendingProperties(with: movementVector)
            velocity = accelerated(initial: movementVector)
        } else {
            currentState = .idle
            velocity = velocity.moveToward(to: .zero, delta: friction)
        }
        updateAnimationConditions()
        _ = moveAndSlide()
    }

    func accelerated(initial: Vector2, normalized: Bool = false) -> Vector2 {
        var movement = initial
        if normalized {
            movement = movement.normalized()
        }
        let acceleration = Vector2(x: acceleration, y: acceleration)
        return (movement * acceleration).limitLength(length: speed)
    }

    func changeSprites() {
        switch character {
        case .chelsea:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_chelsea.png")
        case .obel:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_obel.png")
        }
    }

    @Callable func moveToward(destination: Vector2) {
        currentState = .navigating
        navigator?.targetPosition = destination
    }

    func navigateToNextTarget() {
        guard let navigator else {
            LibAnthrobase.logger.warning("Navigator has (somehow) become nil. Stopping.")
            currentState = .idle
            return
        }

        let nextPosition = navigator.getNextPathPosition()
        if navigator.isTargetReached() || nextPosition == globalPosition {
            currentState = .idle
            return
        }

        let currentPosition = globalPosition
        let newVelocity = nextPosition - currentPosition
        updateBlendingProperties(with: accelerated(initial: newVelocity, normalized: true))
        velocity = newVelocity
        _ = moveAndSlide()
    }

    private func updateBlendingProperties(with vector: Vector2) {
        guard let animationTree else {
            GD.pushError("Animation tree is missing.")
            return
        }

        animationTree.set(property: StringName("parameters/Idle/blend_position"), value: Variant(vector))
        animationTree.set(property: StringName("parameters/Walk/blend_position"), value: Variant(vector))
    }

    private func updateAnimationConditions() {
        animationTree?.set(property: "parameters/conditions/idling",
                           value: (currentState == .idle).toVariant())
        animationTree?.set(property: "parameters/conditions/walking",
                           value: (currentState != .idle).toVariant())
    }
}
