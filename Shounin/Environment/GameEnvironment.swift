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

import SpriteKit
import CranberrySprite
import SKTiled
import Paintbrush

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
    var puzzleTriggers = [SKNode]()
    var player: SKSpriteNode?

    private var stageName: String

    init(stageNamed stage: String) {
        self.stageName = stage
        super.init(size: .init(width: 1600, height: 900))
        self.backgroundColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if let tilemap = SKTilemap.load(tmxFile: "\(stageName).tmx") {
            self.tilemap = tilemap
            addChild(tilemap)

            tilemap.zPosition = -1
            for layer in tilemap.layers {
                configure(for: layer)
            }
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
        guard let tile = layer.children.first else { return }
        let player = GamePlayer(color: .white, size: .init(squareOf: 32))
        let playerBody = SKPhysicsBody(rectangleOf: .init(squareOf: 32))
        playerBody.affectedByGravity = false
        playerBody.allowsRotation = false
        player.physicsBody = playerBody
        player.zPosition = layer.zPosition
        player.position = tile.position
        self.player = player
        addChild(player)

        let camera = SKCameraNode()
        camera.physicsBody = nil
        camera.setScale(0.3)
        self.camera = camera
        player.addChild(camera)
        layer.removeFromParent()
    }

    private func configurePaintbrush(from layer: SKTiledLayerObject) {
        if let expectedLayout = layer.properties["Expected Layout"] {
            puzzleFlow = expectedLayout.split(separator: ",").map { String($0) }
        } else if let configPuzzles = stageConfiguration?.puzzles {
            puzzleFlow = configPuzzles.map { $0.expectedResult }
        }
        puzzleTriggers = layer.children
    }

    private func loadPuzzle() {
        guard let puzzleScene = PaintbrushScene(fileNamed: stageName) else { return }
        puzzleScene.puzzle = self.puzzle
        AppDelegate.previousGameEnvironment = self
    }
}

extension GameEnvironment: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to puzzleConfig: Paintbrush.PaintbrushStagePuzzleConfiguration) {

    }
}

extension GameEnvironment {
    override func keyDown(with event: NSEvent) {
        guard let player else { return }
        switch event.keyCode {
        case 0x0D:
            player.run(.moveBy(x: 0, y: 32, duration: 0.1))
        case 0x00:
            player.run(.moveBy(x: -32, y: 0, duration: 0.1))
        case 0x01:
            player.run(.moveBy(x: 0, y: -32, duration: 0.1))
        case 0x02:
            player.run(.moveBy(x: 32, y: 0, duration: 0.1))
        case 0x31:
            loadPuzzle()
        default:
            print(event.keyCode)
        }
    }
}
