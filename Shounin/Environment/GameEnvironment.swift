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
import GameplayKit

class GameEnvironment: SKScene {
    enum LayerType: String {
        case walkingGraph = "Graph"
        case bounds = "Bounds"
        case playerInsert = "PLAYER_INSERT"
        case paintbrush = "PNT_LAYOUT"
        case paintbrushMetapuzzle = "PNT_LAYOUT_META"
        case other
    }

    var enteredSolveModeForFirstUse = false
    var metapuzzleTrigger = CGPoint.zero
    var player: GamePlayer?
    var puzzle: Paintbrush.PaintbrushStagePuzzleConfiguration?
    var puzzleFlow = [String]()
    var puzzleTriggers = [CGPoint]()
    var solvedPuzzles = Set<String>()
    var stageConfiguration: Paintbrush.PaintbrushStageConfiguration?
    var stageName: String
    var tilemap: SKTilemap?
    var walkableTiles = [SKTile]()
    var walkingLayer: SKTileLayer?

    private var completionCaslonName = ""
    private var preparedForFirstUse = false
    private var tutorialNode: SKNode?

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
           let puzzleTrigger = AppDelegate.observedState.puzzleTriggerName
        { // swiftlint:disable:this opening_brace
            solvedPuzzles.insert(puzzleTrigger)
            if puzzleTrigger == stageConfiguration?.metapuzzle.expectedResult {
                loadEndingCaslonSceneIfPresent()
            }
        }
        prepareSceneForFirstUseIfNecessary()
    }

    /// Returns whether the player is closer to the first point or the second point.
    /// This is used for comparisons and sorting.
    func compareDistanceToPlayer(first: CGPoint, second: CGPoint) -> Bool {
        guard let player else { return false }
        let firstDistance = first.manhattanDistance(to: player.position)
        let secondDistance = second.manhattanDistance(to: player.position)
        return firstDistance < secondDistance
    }

    private func configure(for layer: SKTileLayer) {
        let layerKind = LayerType(rawValue: layer.name ?? "") ?? .other
        switch layerKind {
        case .bounds:
            createBounds(from: layer)
        case .playerInsert:
            createPlayer(from: layer)
        case .paintbrush:
            configurePaintbrush(from: layer)
        case .paintbrushMetapuzzle:
            configurePaintbrushMetapuzzle(from: layer)
        case .walkingGraph:
            createWalkableNodes(from: layer)
        default:
            print("[PNT]: Skipping layer - \(layer.name ?? "unknown layer")")
        }
    }

    private func configurePaintbrush(from layer: SKTileLayer) {
        if let expectedLayout = layer.properties["Expected Layout"] {
            puzzleFlow = expectedLayout.split(separator: ",").map { String($0) }
        } else if let configPuzzles = stageConfiguration?.puzzles {
            puzzleFlow = configPuzzles.map(\.expectedResult)
        }
        let children = layer.tilemap.getTilesWithProperty("Purpose", "puzzle_trigger")
            .filter { $0.layer == layer }
        puzzleTriggers = children.map { tile in
            layer.convert(tile.position, to: self)
        }
    }

    private func configurePaintbrushMetapuzzle(from layer: SKTileLayer) {
        let metaTrigger = layer.tilemap
            .getTilesWithProperty("Purpose", "puzzle_trigger")
            .filter { $0.layer == layer }
            .first
        metapuzzleTrigger = layer.convert(metaTrigger?.position ?? .zero, to: self)
    }

    private func createBounds(from layer: SKTileLayer) {
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

    private func createPlayer(from layer: SKTileLayer) {
        guard let tilemap, let tile = tilemap.getTilesWithProperty("Purpose", "player").first else {
            return
        }
        let player = GamePlayer(position: layer.convert(tile.position, to: self))
        player.zPosition = layer.zPosition
        self.player = player
        addChild(player)

#if os(macOS)
        if AppDelegate.currentFlow.currentBlock?.showTutorials == true,
           let referenceNode = SKReferenceNode(fileNamed: "TutorialKeyLayout")
        {
            tutorialNode = referenceNode
        }
#else
        if AppDelegate.currentFlow.currentBlock?.showTutorials == true,
           let referenceNode = SKReferenceNode(fileNamed: "TutorialTouchLayout")
        {
            tutorialNode = referenceNode
        }
#endif
        if let tutorialNode {
            setUpTutorialNode(tutorial: tutorialNode)
            player.addChild(tutorialNode)
            tutorialNode.run(.fadeAlpha(to: 1.0, duration: 2))
        }

        let camera = SKCameraNode()
        camera.physicsBody = nil
        camera.setScale(0.3)
        camera.position = .zero
        self.camera = camera
        player.addChild(camera)

        if let bokehEffect = SKEmitterNode(fileNamed: "EnvironmentBokeh") {
            bokehEffect.zPosition += player.zPosition + 20
            player.addChild(bokehEffect)
        }

        layer.removeFromParent()
    }

    private func createWalkableNodes(from layer: SKTileLayer) {
        walkingLayer = layer
        getWalkableNodes(from: layer)
        createGraph(in: layer)
        for tile in layer.children {
            guard let spriteTile = tile as? SKSpriteNode else { continue }
            spriteTile.configureForPixelArt()
        }
    }

    /// Dismisses the tutorial node and removes it from the scene tree, if present.
    func dismissTutorialNode() {
        tutorialNode?.runSequence {
            SKAction.fadeAlpha(to: 0, duration: 0.5)
            SKAction.run { [weak self] in
                self?.tutorialNode?.removeFromParent()
                self?.tutorialNode = nil
            }
        }
    }

    /// Displays the solving mode tutorial if it hasn't been displayed already.
    func displaySolvingTutorialIfNeeded() {
        guard AppDelegate.currentFlow.currentBlock?.showTutorials == true,
              !enteredSolveModeForFirstUse,
              tutorialNode == nil,
              playerIsCloseToPuzzle(tolerance: 128) else { return }
#if os(macOS)
        if let carrier = SKReferenceNode(fileNamed: "TutorialSolveKeyLayout") {
            setUpTutorialNode(tutorial: carrier)
            player?.addChild(carrier)
            carrier.run(.fadeAlpha(to: 1.0, duration: 2))
        }
#else
        let tutorialImage = SKSpriteNode(pixelImage: "UI_Tap")
        tutorialImage.size = .init(squareOf: 76)
        let moveLabel = SKLabelNode(text: "Solve")
        moveLabel.fontName = "Salmon Sans 9 Bold"
        moveLabel.fontSize = 54
        let carrier = SKNode()
        carrier.addChild(tutorialImage)
        carrier.addChild(moveLabel)
        moveLabel.position = moveLabel.position.translated(by: .init(x: 0, y: 100))
        setUpTutorialNode(tutorial: carrier)
        if let puzzlePoint = getClosestPuzzlePosition(tolerance: 128) {
            carrier.position = puzzlePoint
        }
        addChild(carrier)
        carrier.zPosition = (player?.zPosition ?? 50) + 20
        carrier.run(.fadeAlpha(to: 1.0, duration: 2))
#endif
    }

    /// Loads the ending Caslon scene if it is present in the game's files.
    func loadEndingCaslonSceneIfPresent() {
        guard let vnScene = CaslonScene(fileNamed: "Caslon Scene") else { return }
        vnScene.scaleMode = scaleMode
        vnScene.loadScript(named: completionCaslonName)
        view?.presentScene(vnScene, transition: .fade(withDuration: 3.0))
    }

    private func prepareSceneForFirstUseIfNecessary() {
        if preparedForFirstUse { return }
        readPuzzleConfiguration(from: stageName)
        if let tilemap = SKTilemap.load(tmxFile: "\(stageName).tmx") {
            self.tilemap = tilemap
            addChild(tilemap)

            tilemap.zPosition = -1
            for layer in tilemap.layers {
                if let realLayer = layer as? SKTileLayer {
                    configure(for: realLayer)
                }
            }
            preparedForFirstUse = true
        }
    }

    /// Sets the ending Caslon scene that will be loaded.
    func setEndingScene(to caslonName: String) {
        completionCaslonName = caslonName
    }

    private func setUpTutorialNode(tutorial: SKNode) {
        tutorial.zPosition += 20
        tutorial.setScale(0.3)
        tutorial.alpha = 0
        tutorialNode = tutorial

        tutorial.apply(recursively: true) { child in
            if let sprite = child as? SKSpriteNode {
                sprite.texture?.configureForPixelArt()
            }
        }
    }
}

extension GameEnvironment: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to _: Paintbrush.PaintbrushStagePuzzleConfiguration) {}
}
