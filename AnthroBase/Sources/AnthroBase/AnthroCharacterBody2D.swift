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

/// A character body that represents an anthropomorphic character in game.
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

    /// The character that this player represents.
    @AutovariantEnum public var character: Character = .chelsea {
        didSet { changeSprites() }
    }

    /// The rate at which the character will accelerate.
    @Autovariant public var acceleration: Int

    /// The scalar friction force the player receives.
    @Autovariant public var friction: Int

    /// The speed at which the player will move.
    @Autovariant public var speed: Int

    @SceneTree(path: "Camera") var camera: Camera2D?
    @SceneTree(path: "Sprite/AnimationTree") var animationTree: AnimationTree?
    @SceneTree(path: "Sprite/AnimationPlayer") var animationPlayer: AnimationPlayer?
    @SceneTree(path: "Navigator") var navigator: NavigationAgent2D?
    @SceneTree(path: "Sprite") var sprite: Sprite2D?

    var animationState: AnimationNodeStateMachinePlayback?
    var currentState = PlayerState.idle
    var indicator: Sprite2D?

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

        // Disable playback in editor so we're not running into constant saves...
        animationTree?.active = !Engine.isEditorHint()

        animationState = animationTree?.get(property: StringName("parameters/playback")).asObject()
        LibAnthrobase.logger.debug("Animation state is: \(String(describing: animationState))")

        navigator?.pathDesiredDistance = 4
        navigator?.targetDesiredDistance = 4
    }

    override public func _unhandledInput(event: InputEvent?) {
        super._unhandledInput(event: event)
        guard let event else { return }

        if event.isClass("\(InputEventScreenTouch.self)"), event.isPressed() {
            var newPosition = Vector2(event.get(property: "position")) ?? .zero
            if let transform = getViewport()?.canvasTransform {
                newPosition = newPosition * transform // swiftlint:disable:this shorthand_operator
            }

            do {
                try getTree()?.physicsFrame.connect { [weak self] in
                    _ = self?.callDeferred(method: "move_toward", newPosition.toVariant())
                }
            } catch {
                LibAnthrobase.logger.error("Unable to connect signal: \(error)")
            }

        }
    }

    override public func _process(delta: Double) {
        super._process(delta: delta)

        if let indicator, globalPosition.distanceTo(to: indicator.position) < 32 {
            indicator.visible = false
        }
    }

    override public func _physicsProcess(delta: Double) {
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
            velocity = velocity.moveToward(to: .zero, delta: Double(friction))
        }
        updateAnimationConditions()
        _ = moveAndSlide()
    }

    func accelerated(initial: Vector2, normalized: Bool = false) -> Vector2 {
        var movement = initial
        if normalized {
            movement = movement.normalized()
        }
        let accelFloat = Float(acceleration)
        let acceleration = Vector2(x: accelFloat, y: accelFloat)
        return (movement * acceleration).limitLength(length: Double(speed))
    }

    func changeSprites() {
        switch character {
        case .chelsea:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_chelsea.png")
        case .obel:
            sprite?.texture = #texture2DLiteral("res://resources/sprt_obel.png")
        }
    }

    func createTapIndicator(at destination: Vector2) {
        let newSprite = Sprite2D()
        newSprite.texture = #texture2DLiteral("res://resources/gui/tap_indicator.png")
        newSprite.textureFilter = .nearest
        newSprite.globalPosition = destination
        newSprite.name = "#TAPINDICATOR"
        newSprite.scale = .init(x: 2, y: 2)
        getParent()?.addChild(node: newSprite)
        indicator = newSprite
    }
    
    @Callable func moveToward(destination: Vector2) {
        currentState = .navigating
        navigator?.targetPosition = destination

        if let indicator {
            indicator.visible = true
            indicator.globalPosition = destination
        } else {
            createTapIndicator(at: destination)
        }
    }

    func navigateToNextTarget() {
        guard let navigator else {
            LibAnthrobase.logger.warning("Navigator has (somehow) become nil. Stopping.")
            currentState = .idle
            indicator?.visible = false
            return
        }

        let nextPosition = navigator.getNextPathPosition()
        if navigator.isTargetReached() || nextPosition == globalPosition {
            currentState = .idle
            indicator?.visible = false
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
