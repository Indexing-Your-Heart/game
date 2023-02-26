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
import GameplayKit
import Logging
import Paintbrush
import SKTiled
import SpriteKit

/// A SpriteKit scene that represents the primary game environment.
class GameEnvironment: SKScene {
    /// An enumeration that encodes layer names to corresponding types. This is used for world setup to perform certain
    /// tasks such as gathering walkable tiles for pathfinding.
    enum LayerType: String {
        /// The layer that represents the walkable tiles used for the graph.
        case walkingGraph = "Graph"

        /// The layer that represents the bounds where the player cannot cross.
        case bounds = "Bounds"

        /// The layer that contains information on where the player exists.
        case playerInsert = "PLAYER_INSERT"

        /// The layer that contains information on how puzzles are laid out in the world.
        case paintbrush = "PNT_LAYOUT"

        /// The layer that contains informaton on how the metapuzzle is laid out in the world.
        case paintbrushMetapuzzle = "PNT_LAYOUT_META"

        /// A generic, unspecified layer.
        case other
    }

    /// The name of the Caslon scene that should be played when the player finishes the metapuzzle.
    var completionCaslonName = ""

    /// Whether the player has entered solve mode for the first time.
    /// Internally, this is used to determine whether the tutorial for solving a puzzle should be displayed on screen.
    var enteredSolveModeForFirstUse = false

    /// The game environment delegate used to communicate with all systems.
    var environmentDelegate: GameEnvironmentDelegate?

    /// The game environment's logging facility to log messages.
    var logger = Logger(label: "shounin_env")

    /// The position of the metapuzzle trigger.
    var metapuzzleTrigger = CGPoint.zero

    /// The node that refers to the player.
    var player: GamePlayer?

    /// The current puzzle in the environment's context.
    var puzzle: Paintbrush.PaintbrushStagePuzzleConfiguration?

    /// An array of strings indicating the preferred order of puzzles when being laid out in the world.
    var puzzleFlow = [String]()

    /// An array of points where puzzle triggers are located.
    var puzzleTriggers = [CGPoint]()

    /// A set of puzzles that the player has completed.
    var solvedPuzzles = Set<String>()

    /// The Paintbrush stage configuration that corresponds to this level.
    var stageConfiguration: Paintbrush.PaintbrushStageConfiguration?

    /// The environment's stage name.
    var stageName: String

    /// The tilemap node used to render the world.
    var tilemap: SKTilemap?

    /// The tutorial node that displays hints on how to move or interact in the world.
    var tutorialNode: SKNode?

    /// An array of tiles that the player can walk on. This is used for pathfinding.
    var walkableTiles = [SKTile]()

    /// The tilemap layer that includes walkable tiles. This is used for pathfinding.
    var walkingLayer: SKTileLayer?

    private var preparedForFirstUse = false

    /// Creates a game environment from a given stage name.
    /// - Parameter stage: The stage name to initialize the environment with.
    init(stageNamed stage: String) {
        stageName = stage
        super.init(size: .init(width: 1600, height: 900))
        backgroundColor = .black
        environmentDelegate = self
#if DEBUG
        logger.logLevel = .debug
#endif
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if AppDelegate.observedState.previousEnvironment == self {
            AppDelegate.observedState.previousEnvironment = nil
        }

        if AppDelegate.observedState.previousPuzzleState == .solved,
           let puzzleTrigger = AppDelegate.observedState.puzzleTriggerName
        { // swiftlint:disable:this opening_brace
            solvedPuzzles.insert(puzzleTrigger)
            if puzzleTrigger == stageConfiguration?.metapuzzle.expectedResult {
                environmentDelegate?.loadEndingCaslonSceneIfPresent()
            }
        }
        prepareSceneForFirstUseIfNecessary()
        setUpAmbientSoundscape()
    }

    /// Displays the solving mode tutorial if it hasn't been displayed already.
    func displaySolvingTutorialIfNeeded() {
        guard shouldDisplaySolvingTutorialNode() else { return }
#if os(macOS)
        if let carrier = SKReferenceNode(fileNamed: "TutorialSolveKeyLayout") {
            environmentDelegate?.setUpTutorialNode(tutorial: carrier)
            player?.addChild(carrier)
            carrier.run(.fadeAlpha(to: 1.0, duration: 2))
        }
#else
        let tutorialImage = SKSpriteNode(pixelImage: "UI_Tap")
        tutorialImage.size = .init(squareOf: 76)
        let moveLabel = SKLabelNode(text: "Solve", with: "Salmon Sans 9 Bold", at: 45)

        let carrier = CSStackNode(alignment: .vertical, spacing: 32)
        carrier.addArrangedChildren([tutorialImage, moveLabel])

        environmentDelegate?.setUpTutorialNode(tutorial: carrier)
        if let puzzlePoint = environmentDelegate?.getClosestPuzzlePosition(tolerance: 128) {
            carrier.position = puzzlePoint
        }

        addChild(carrier)
        carrier.zPosition = (player?.zPosition ?? 50) + 20
        carrier.run(.fadeAlpha(to: 1.0, duration: 2))
#endif
    }

    func walkToSpecifiedLocation(at location: CGPoint, speed: CGFloat = 1, completion: (() -> Void)? = nil) {
        guard let player else { return }
        if let moveActions = environmentDelegate?.actions(with: path(to: location), speed: speed) {
            player.removeAllActions()
            player.runSequence {
                SKAction.run { [weak self] in
                    self?.dismissTutorialNode()
                }
                SKAction.sequence(moveActions)
                SKAction.run { [weak self] in
                    self?.displaySolvingTutorialIfNeeded()
                    completion?()
                    self?.environmentDelegate?.loadClosestPuzzleToPlayer()
                }
            }
        }
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
            logger.info("Skipping layer - \(layer.name ?? "unknown layer")")
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
            spriteTile.physicsBody = .immovableObject(sized: spriteTile.size)
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

        tutorialNode = environmentDelegate?.getMovementTutorialReferenceNode()
        if let tutorialNode {
            environmentDelegate?.setUpTutorialNode(tutorial: tutorialNode)
            player.addChild(tutorialNode)
            tutorialNode.run(.fadeAlpha(to: 1.0, duration: 2))
        }

        let camera = SKCameraNode()
        camera.physicsBody = nil
        camera.setScale(0.3)
        camera.position = .zero
        self.camera = camera
        player.addChild(camera)
        listener = camera

        if let bokehEffect = SKEmitterNode(fileNamed: "EnvironmentBokeh") {
            bokehEffect.zPosition += player.zPosition + 20
            player.addChild(bokehEffect)
        }

        layer.removeFromParent()
    }

    private func createWalkableNodes(from layer: SKTileLayer) {
        walkingLayer = layer
        environmentDelegate?.getWalkableNodes(from: layer)
        createGraph(in: layer)
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
        }
        preparedForFirstUse = true
    }

    private func setUpAmbientSoundscape() {
        buildSoundscape(listeningTo: player) {
            Ambience(name: "amb_room_still", volume: 0.1)
        }
    }

    private func shouldDisplaySolvingTutorialNode() -> Bool {
        guard let environmentDelegate else { return false }
        return environmentDelegate.tutorialShouldBeDisplayed() && tutorialNode == nil && environmentDelegate
            .playerIsCloseToPuzzle(tolerance: 128)
    }
}
