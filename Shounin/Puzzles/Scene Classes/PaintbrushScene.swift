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

    var painting: SKSpriteNode?

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
            readPuzzleConfiguration(from: name)
        }
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
}
