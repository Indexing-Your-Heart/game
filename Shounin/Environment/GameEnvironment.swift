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
        case paintbrushMetapuzzle = "PNT_LAYOUT_META"
        case other
    }

    var metapuzzleTrigger = CGPoint.zero
    var player: SKSpriteNode?
    var puzzle: Paintbrush.PaintbrushStagePuzzleConfiguration?
    var puzzleFlow = [String]()
    var puzzleTriggers = [CGPoint]()
    var solvedPuzzles = Set<String>()
    var stageConfiguration: Paintbrush.PaintbrushStageConfiguration?
    var tilemap: SKTilemap?

    private var completionCaslonName = ""
    private var preparedForFirstUse = false
    private var stageName: String
    private var tutorialNode: SKNode?
    private var enteredSolveModeForFirstUse = false

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

    private func configure(for layer: SKTiledLayerObject) {
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
        case .other:
            print("[PNT]: Skipping layer - \(layer.name ?? "unknown layer")")
        }
    }

    private func configurePaintbrush(from layer: SKTiledLayerObject) {
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

    private func configurePaintbrushMetapuzzle(from layer: SKTiledLayerObject) {
        let metaTrigger = layer.tilemap
            .getTilesWithProperty("Purpose", "puzzle_trigger")
            .filter { $0.layer == layer }
            .first
        metapuzzleTrigger = layer.convert(metaTrigger?.position ?? .zero, to: self)
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
        layer.removeFromParent()
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

    /// Returns whether the player is close to a puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func playerIsCloseToPuzzle(tolerance: Int) -> Bool {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return false }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance)
    }

    /// Returns the position of the closest puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func getClosestPuzzlePosition(tolerance: Int) -> CGPoint? {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return nil }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance) ? closestPuzzle : nil
    }

    /// Loads the current puzzle if the player is near a puzzle panel and a puzzle exists for it.
    func loadPuzzleIfPresent() {
        guard let puzzleScene = PaintbrushScene(fileNamed: stageName), let puzzle else { return }
        puzzleScene.scaleMode = scaleMode
        puzzleScene.puzzle = puzzle
        AppDelegate.observedState.previousEnvironment = self
        AppDelegate.observedState.puzzleTriggerName = puzzle.expectedResult
        view?.presentScene(puzzleScene)
    }

    /// Loads the ending Caslon scene if it is present in the game's files.
    func loadEndingCaslonSceneIfPresent() {
        guard let vnScene = CaslonScene(fileNamed: "Caslon Scene") else { return }
        vnScene.scaleMode = scaleMode
        vnScene.loadScript(named: completionCaslonName)
        view?.presentScene(vnScene, transition: .fade(withDuration: 3.0))
    }

    /// Loads the puzzle that is closest to the player.
    func loadClosestPuzzleToPlayer() {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        let puzzleIdx = allPuzzleTriggers.firstIndex(of: closestPuzzle)
        if distanceFromPlayer <= 32, let idx = puzzleIdx {
            if puzzleIdx == allPuzzleTriggers.firstIndex(of: metapuzzleTrigger) {
                guard let metaConfig = stageConfiguration?.metapuzzle else { return }
                let metapuzzle = PaintbrushStagePuzzleConfiguration(
                    paintingName: "",
                    expectedResult: metaConfig.expectedResult,
                    palette: metaConfig.palette
                )
                puzzle = metapuzzle
            } else {
                puzzle = stageConfiguration?.puzzles.first { $0.expectedResult == puzzleFlow[idx] }
            }
            enteredSolveModeForFirstUse = true
            loadPuzzleIfPresent()
        }
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
