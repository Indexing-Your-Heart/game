//
//  PaintbrushScene+Solving.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/4/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import SpriteKit
import Paintbrush

// MARK: - Puzzle Configuration

extension PaintbrushScene: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to puzzleConfig: PaintbrushStagePuzzleConfiguration) {
        if let panelDrawingArea {
            panelDrawingArea.fillColor = SKColor(hexString: puzzleConfig.palette.panelColor)
        }
        if let painting {
            painting.texture = .init(imageNamed: puzzleConfig.paintingName)
            painting.configureForPixelArt()
        }
    }
}

// MARK: - Panel Interactions

extension PaintbrushScene: PanelInteractionDelegate {
    func panelWillStartDrawing(at location: CGPoint) {
        createDrawingNode(at: location)
    }

    func panelWillMoveDrawing(to location: CGPoint) {
        createDrawingNode(at: location)
    }

    func panelWillFinishDrawing(at location: CGPoint) {
        createDrawingNode(at: location)
    }

    func panelWillHighlight(onPredictionStatus prediction: Bool) {
        guard let path = drawingDelegateNode?.childNode(withName: "witPath") as? SKShapeNode else { return }
        if prediction {
            path.strokeColor = SKColor(hexString: puzzle?.palette.panelLineColor ?? "#000000")
            return
        }
    }

    func panelDidHighlight(onPredictionStatus prediction: Bool) {
        guard let path = drawingDelegateNode?.childNode(withName: "witPath") as? SKShapeNode else { return }
        let pathColor = path.strokeColor.blended(withFraction: 0.7, of: .black) ?? path.strokeColor
        if prediction { return }
        path.run(
            .sequence([
                .repeat(
                    .sequence([
                        .colorizeStroke(to: .red, duration: 0.5),
                        .colorizeStroke(to: pathColor, duration: 0.5)
                    ]),
                    count: 5
                ),
                .fadeOut(withDuration: 5.0)
            ])
        ) {
            path.removeFromParent()
        }
    }
}

// MARK: - Paintbrush Validation

extension PaintbrushScene: PaintbrushSolver {
    func makePathFromChildren() -> SKShapeNode? {
        guard let drawingPoints = getDrawingPoints() else { return nil }
        let drawnPath = CGMutablePath()
        for points in drawingPoints.windows(ofCount: 2) {
            guard let current = points.first, let next = points.last else { continue }
            drawnPath.move(to: current.position)
            drawnPath.addQuadCurve(to: next.position, control: current.position)
        }
        drawingPoints.forEach { $0.removeFromParent() }
        let pathNode = SKShapeNode(
            path: drawnPath,
            stroke: .init(hexString: puzzle?.palette.panelLineColor ?? "#000000")
        )
        pathNode.name = "witPath"
        return pathNode
    }

    func getCanvasImageFromScene() -> CGImage? {
        guard let panelDrawingArea, let drawingDelegateNode else { return nil }
        panelDrawingArea.fillColor = .black
        panelDrawingArea.lineWidth = 0
        guard let line = drawingDelegateNode.childNode(withName: "witPath") as? SKShapeNode else { return nil }
        line.strokeColor = .white
        guard let texture = view?.texture(from: drawingDelegateNode, crop: panelDrawingArea.frame) else {
            line.strokeColor = SKColor(hexString: puzzle?.palette.panelLineColor ?? "#000000")
            panelDrawingArea.fillColor = SKColor(hexString: puzzle?.palette.panelColor ?? "#ffffff")
            panelDrawingArea.lineWidth = 4
            return nil
        }
        if let debugNode = childNode(withName: "debugSprite") as? SKSpriteNode {
            debugNode.texture = texture
        }
        line.strokeColor = SKColor(hexString: puzzle?.palette.panelLineColor ?? "#000000")
        panelDrawingArea.fillColor = SKColor(hexString: puzzle?.palette.panelColor ?? "#ffffff")
        panelDrawingArea.lineWidth = 4
        return texture.cgImage()
    }

    func makePrediction(from cgImage: CGImage) throws -> [String] {
        let classifier = try PrototypeValidator(configuration: .init())
        let predictions = try classifier.prediction(input: .init(imageWith: cgImage))
            .classLabelProbs
            .max(count: 3, sortedBy: { $0.value < $1.value }).reversed()
        return predictions.map(\.key)
    }
}
