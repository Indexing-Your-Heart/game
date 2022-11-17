//
//  GamePlayer.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/6/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import CranberrySprite
import SKTiled
import SpriteKit

/// A sprite that represents the player.
class GamePlayer: SKSpriteNode {
    /// A typealias referencing the class that contains the player's texture atlas.
    typealias TextureAtlas = GameEnvironmentPlayerAtlas

    /// An enumeration for the different directions a player can face or walk.
    enum Direction {
        case up // swiftlint:disable:this identifier_name
        case down
        case left
        case right
        case stop
    }

    /// The current direction the player is facing when walking.
    var walkingDirection: Direction = .stop

    /// The current direction the player is facing when idling.
    var facingDirection: Direction = .down

    private var isMoving = false
    private var atlas = TextureAtlas()
    private var frameRate: TimeInterval = 1 / 6

    /// Creates a player at a specified position.
    /// - Parameter position: The position in the SpriteKit scene to set the player at.
    init(position: CGPoint) {
        walkingDirection = .stop
        facingDirection = .down
        super.init(texture: nil, color: .white, size: .init(width: 32, height: 64))
        self.position = position
        setPhysicsBody()
        updateIdleSpriteAnimation()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns whether the player is closer to the first point or the second point.
    /// This is used for comparisons and sorting.
    func compareDistancesToPoints(first: CGPoint, second: CGPoint) -> Bool {
        let firstDistance = first.manhattanDistance(to: position)
        let secondDistance = second.manhattanDistance(to: position)
        return firstDistance < secondDistance
    }

    /// Returns the player's tile coordiantes with respect to a specified layer.
    /// This is used to determine the player's location in pathfinding and navigation.
    /// - Parameter layer: The layer to get the tile coordinates of the player from.
    func getCoordinates(withRespectTo layer: SKTileLayer) -> CGPoint {
        guard let scene else { return position }
        let layerPos = layer.convert(position, from: scene)
        return layer.coordinateForPoint(layerPos)
    }

    /// Moves the player in a specified direction, updating the sprites as necessary.
    /// - Parameter direction: The direction for the player to move in.
    func move(in direction: Direction) {
        if walkingDirection == direction { return }
        walkingDirection = direction
        facingDirection = direction
        updateWalkSpriteAnimation()
        isMoving = true
    }

    /// Stops the player's movement and updates the sprites to an idling state.
    func stopMoving() {
        guard isMoving else { return }
        facingDirection = walkingDirection
        walkingDirection = .stop
        updateIdleSpriteAnimation()
        isMoving = false
    }

    private func setPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: .init(squareOf: 32))
        body.affectedByGravity = false
        body.allowsRotation = false
        physicsBody = body
    }

    private func updateIdleSpriteAnimation() {
        var idleSet = [SKTexture]()
        switch facingDirection {
        case .up:
            idleSet = atlas.chelsea_idle_up_()
        case .left:
            idleSet = atlas.chelsea_idle_left_()
        case .right:
            idleSet = atlas.chelsea_idle_right_()
        default:
            idleSet = atlas.chelsea_idle_down_()
        }
        idleSet.forEach { sprite in sprite.configureForPixelArt() }
        run(
            .repeatForever(.animate(with: idleSet, timePerFrame: frameRate, resize: false, restore: false))
        )
    }

    private func updateWalkSpriteAnimation() {
        var walkSet = [SKTexture]()
        switch walkingDirection {
        case .up:
            walkSet = atlas.chelsea_walk_up_()
        case .left:
            walkSet = atlas.chelsea_walk_left_()
        case .right:
            walkSet = atlas.chelsea_walk_right_()
        default:
            walkSet = atlas.chelsea_walk_down_()
        }
        walkSet.forEach { sprite in sprite.configureForPixelArt() }
        run(
            .repeatForever(.animate(with: walkSet, timePerFrame: frameRate, resize: false, restore: false))
        )
    }
}
