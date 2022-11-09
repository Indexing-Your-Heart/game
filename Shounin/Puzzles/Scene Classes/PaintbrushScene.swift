//
//  PaintbrushScene.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/28/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Algorithms
import CoreML
import CranberrySprite
import Paintbrush
import SpriteKit

/// A SpriteKit scene that represents an interactable play area for solving puzzles.
class PaintbrushScene: SKScene {
    var panelDrawingArea: SKShapeNode?
    var drawingDelegateNode: SKNode?
    var stageConfiguration: PaintbrushStageConfiguration?
    var puzzle: PaintbrushStagePuzzleConfiguration? {
        didSet {
            guard let puzzle else { return }
            didSetPuzzleConfiguration(to: puzzle)
        }
    }

    var solveState: PaintbrushSolveState = .unsolved
    var painting: SKSpriteNode?

    var showingTutorialHint = false {
        didSet { updateTutorialHintState() }
    }

    convenience init?(fileNamed file: String, debug debugMode: Bool = false) {
        self.init(fileNamed: file)
        childNode(withName: "//debugSprite")?.isHidden = !debugMode
    }

    override func didMove(to _: SKView) {
        if let delegate = childNode(withName: "//delegate") {
            drawingDelegateNode = delegate
        }
        if let panel = drawingDelegateNode?.childNode(withName: "panel") as? SKShapeNode {
            panelDrawingArea = panel
        }
        if let paintingSprite = childNode(withName: "//painting") as? SKSpriteNode {
            painting = paintingSprite
        }
        if let name {
            configureWithPrexistingPuzzleIfPresent { [weak self] in
                self?.readPuzzleConfiguration(from: name)
            }
        }
        if let exitButton = childNode(withName: "//exitButton") as? SKSpriteNode {
            exitButton.configureForPixelArt()
        }
        childNode(withName: "//debugSprite")?.isHidden = true
        loadSolvedStateIfPresent()
        presentTutorialHintIfPresent()
    }

    func enableDebuggingFeatures() {
        childNode(withName: "//debugSprite")?.isHidden = false
    }

    func presentTutorialHintIfPresent() {
        guard let hintRequired = puzzle?.showTutorialHint,
              let hint = childNode(withName: "//tutorialHint") as? SKSpriteNode else {
            childNode(withName: "//tutorialHint")?.removeFromParent()
            return
        }
        guard hintRequired == true, solveState != .solved else {
            hint.removeFromParent()
            return
        }
        hint.texture?.configureForPixelArt()
#if os(macOS)
        let dragTexture = SKTexture(imageNamed: "UI_Tutorial_Drag")
        dragTexture.configureForPixelArt()
        hint.texture = dragTexture
#endif
    }

    func updateTutorialHintState() {
        if showingTutorialHint {
            return
        }
        childNode(withName: "//tutorialHint")?.removeFromParent()
    }

    /// Creates a node to be used in the final path.
    /// - Returns: A node included in the final path, or `nil` if the location is out of bounds.
    @discardableResult
    func createDrawingNode(at location: CGPoint) -> SKNode? {
        if let previousLine = drawingDelegateNode?.childNode(withName: "witPath") {
            previousLine.removeFromParent()
        }
        guard let panelDrawingArea, panelDrawingArea.frame.contains(location) else { return nil }
        let drawPoint = SKNode()
        drawPoint.position = location
        drawingDelegateNode?.addChild(drawPoint)
        return drawPoint
    }

    /// Returns the drawn path nodes from the player.
    func getDrawingPoints() -> [SKNode]? {
        drawingDelegateNode?.children.filter { $0 != panelDrawingArea }
    }

    /// Loads the next puzzle in the set.
    /// - Important: Only use this in a debugging context.
    func nextPuzzle() {
        guard let stageConfiguration else { return }
        if let currentIdx = stageConfiguration.puzzles
            .firstIndex(where: { $0.paintingName == puzzle?.paintingName }),
            currentIdx + 1 < stageConfiguration.puzzles.count
        { // swiftlint:disable:this opening_brace
            let newIdx = currentIdx + 1
            puzzle = stageConfiguration.puzzles[newIdx]
        }
    }

    /// Dismisses the scene and restores the previous game environment.
    func dismissIfPresent() {
        guard let previousScene = AppDelegate.observedState.previousEnvironment else { return }
        AppDelegate.observedState.previousPuzzleState = solveState
        if solveState == .solved {
            savePlayerDrawingForReuse()
        }

        view?.presentScene(previousScene)
    }

    private func configureWithPrexistingPuzzleIfPresent(handler: @escaping () -> Void) {
        let previousPuzzle = puzzle
        handler()
        if let previousPuzzle {
            puzzle = previousPuzzle
        }
    }

    private func savePlayerDrawingForReuse() {
        guard let puzzle, let image = getImageForSolvedCanvas() else { return }
        image.write(to: "solved_" + puzzle.expectedResult)
    }

    private func loadSolvedStateIfPresent() {
        guard let puzzle else { return }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let firstPath = paths[0]
        let url = firstPath.appending(path: "solved_\(puzzle.expectedResult)")
            .appendingPathExtension("png")
        _ = url.startAccessingSecurityScopedResource()
        guard let solvedNode = childNode(withName: "//solveOverlay") as? SKSpriteNode else { return }
        if let tex = SKTexture(contentsOf: url) {
            solvedNode.texture = tex
        } else {
            solvedNode.isHidden = true
        }
        url.stopAccessingSecurityScopedResource()
    }

    func getImageForSolvedCanvas() -> CGImage? {
        guard let panelDrawingArea, let drawingDelegateNode, solveState == .solved else { return nil }
        panelDrawingArea.lineWidth = 0
        guard let texture = view?.texture(from: drawingDelegateNode, crop: panelDrawingArea.frame) else {
            panelDrawingArea.lineWidth = 4
            return nil
        }
        panelDrawingArea.lineWidth = 4
        return texture.cgImage()
    }
}
