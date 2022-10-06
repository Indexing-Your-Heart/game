//
//  GameEnvironment.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/5/22.
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
import Paintbrush
import SKTiled
import SpriteKit

class GameEnvironment: SKScene {
    enum LayerType: String {
        case bounds = "Bounds"
        case playerInsert = "PLAYER_INSERT"
        case paintbrush = "PNT_LAYOUT"
        case other
    }

    var tilemap: SKTilemap?
    var stageConfiguration: Paintbrush.PaintbrushStageConfiguration?
    var puzzle: Paintbrush.PaintbrushStagePuzzleConfiguration?
    var puzzleFlow = [String]()
    var puzzleTriggers = [CGPoint]()
    var player: SKSpriteNode?
    var solvedPuzzles = [String]()

    private var stageName: String
    private var preparedForFirstUse = false

    init(stageNamed stage: String) {
        stageName = stage
        super.init(size: .init(width: 1600, height: 900))
        backgroundColor = .black
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if AppDelegate.observedState.previousPuzzleState == .solved,
           let puzzleTrigger = AppDelegate.observedState.puzzleTriggerName {
            solvedPuzzles.append(puzzleTrigger)
        }
        prepareSceneForFirstUseIfNecessary()
    }

    private func prepareSceneForFirstUseIfNecessary() {
        if preparedForFirstUse { return }
        readPuzzleConfiguration(from: stageName)
        if let tilemap = SKTilemap.load(tmxFile: "\(stageName).tmx") {
            self.tilemap = tilemap
            addChild(tilemap)

            tilemap.zPosition = -1
            for layer in tilemap.layers {
                configure(for: layer)
            }
            preparedForFirstUse = true
        }
    }

    private func configure(for layer: SKTiledLayerObject) {
        let layerKind = LayerType(rawValue: layer.name ?? "") ?? .other
        switch layerKind {
        case .bounds:
            createBounds(from: layer)
        case .playerInsert:
            createPlayer(from: layer)
        case .paintbrush:
            configurePaintbrush(from: layer)
        case .other:
            print("Skipping layer: \(layer.name ?? "unknown layer")")
        }
    }

    private func createBounds(from layer: SKTiledLayerObject) {
        for tile in layer.children {
            guard let spriteTile = tile as? SKSpriteNode else { continue }
            spriteTile.configureForPixelArt()
            let physicsBody = SKPhysicsBody(rectangleOf: spriteTile.size)
            physicsBody.affectedByGravity = false
            physicsBody.allowsRotation = false
            physicsBody.isDynamic = false
            spriteTile.physicsBody = physicsBody
        }
    }

    private func createPlayer(from layer: SKTiledLayerObject) {
        guard let tilemap, let tile = tilemap.getTilesWithProperty("Purpose", "player").first else {
            return

        }
        let player = GamePlayer(position: layer.convert(tile.position, to: self))
        player.zPosition = layer.zPosition
        self.player = player
        addChild(player)

        let camera = SKCameraNode()
        camera.physicsBody = nil
        camera.setScale(0.3)
        camera.position = .zero
        self.camera = camera
        player.addChild(camera)
        layer.removeFromParent()
    }

    private func configurePaintbrush(from layer: SKTiledLayerObject) {
        if let expectedLayout = layer.properties["Expected Layout"] {
            puzzleFlow = expectedLayout.split(separator: ",").map { String($0) }
        } else if let configPuzzles = stageConfiguration?.puzzles {
            puzzleFlow = configPuzzles.map(\.expectedResult)
        }
        let children = layer.tilemap.getTilesWithProperty("Purpose", "puzzle_trigger")
        puzzleTriggers = children.map { tile in
            layer.convert(tile.position, to: self)
        }
    }

    func loadPuzzleIfPresent() {
        guard let puzzleScene = PaintbrushScene(fileNamed: stageName), let puzzle else { return }
        puzzleScene.scaleMode = self.scaleMode
        puzzleScene.puzzle = puzzle
        AppDelegate.observedState.previousEnvironment = self
        AppDelegate.observedState.puzzleTriggerName = puzzle.expectedResult
        view?.presentScene(puzzleScene)
    }

    func compareDistanceToPlayer(first: CGPoint, second: CGPoint) -> Bool {
        guard let player else { return false }
        let firstDistance = first.manhattanDistance(to: player.position)
        let secondDistance = second.manhattanDistance(to: player.position)
        return firstDistance < secondDistance
    }
}

extension GameEnvironment: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to _: Paintbrush.PaintbrushStagePuzzleConfiguration) {}
}
