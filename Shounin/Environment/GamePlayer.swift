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
import SpriteKit
import SKTiled

class GamePlayer: SKSpriteNode {
    enum Direction {
        case up // swiftlint:disable:this identifier_name
        case down
        case left
        case right
        case stop
    }

    var walkingDirection: Direction = .stop
    var facingDirection: Direction = .down
    private var isMoving = false

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

    private func setPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: .init(squareOf: 32))
        body.affectedByGravity = false
        body.allowsRotation = false
        physicsBody = body
    }

    func getCoordinates(withRespectTo layer: SKTileLayer) -> CGPoint {
        guard let scene else { return position }
        let layerPos = layer.convert(position, from: scene)
        return layer.coordinateForPoint(layerPos)
    }

    func move(in direction: Direction) {
        if walkingDirection == direction { return }
        walkingDirection = direction
        facingDirection = direction
        updateWalkSpriteAnimation()
        isMoving = true
    }

    func stopMoving() {
        guard isMoving else { return }
        facingDirection = walkingDirection
        walkingDirection = .stop
        updateIdleSpriteAnimation()
        isMoving = false
    }

    private func updateIdleSpriteAnimation() {
        let atlas = GameEnvironmentPlayerAtlas()
        let frameRate: TimeInterval = 1/6
        var idleSet = [SKTexture]()
        switch walkingDirection {
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
        let atlas = GameEnvironmentPlayerAtlas()
        let frameRate: TimeInterval = 1/6
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
