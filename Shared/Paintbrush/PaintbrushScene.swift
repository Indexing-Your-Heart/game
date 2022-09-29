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
import SpriteKit

class PaintbrushScene: SKScene {
    var panelDrawingArea: SKShapeNode?
    var drawingDelegateNode: SKNode?

    override func didMove(to _: SKView) {
        if let delegate = childNode(withName: "//delegate") {
            drawingDelegateNode = delegate
        }
        if let panel = drawingDelegateNode?.childNode(withName: "panel") as? SKShapeNode {
            panelDrawingArea = panel
        }
    }

    private func createDrawingNode(at location: CGPoint) -> SKNode {
        let drawPoint = SKNode()
        drawPoint.position = location
        drawingDelegateNode?.addChild(drawPoint)
        return drawPoint
    }

    private func getDrawingPoints() -> [SKNode]? {
        drawingDelegateNode?.children.filter { $0 != panelDrawingArea }
    }
}

// MARK: - Panel Interactions

extension PaintbrushScene: PanelInteractionDelegate {
    func panelWillStartDrawing(at location: CGPoint) {
        let drawPoint = createDrawingNode(at: location)
    }

    func panelWillMoveDrawing(to location: CGPoint) {
        let drawPoint = createDrawingNode(at: location)
    }

    func panelWillFinishDrawing(at location: CGPoint) {
        let drawPoint = createDrawingNode(at: location)
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
        let pathNode = SKShapeNode(path: drawnPath)
        pathNode.name = "witPath"
        pathNode.strokeColor = .black
        pathNode.lineJoin = .round
        pathNode.lineCap = .round
        pathNode.lineWidth = 16
        return pathNode
    }

    func getCanvasImageFromScene() -> CGImage? {
        guard let panelDrawingArea, let drawingDelegateNode else { return nil }
        panelDrawingArea.fillColor = .black
        guard let line = drawingDelegateNode.childNode(withName: "witPath") as? SKShapeNode else { return nil }
        line.strokeColor = .white
        guard let texture = view?.texture(from: drawingDelegateNode, crop: panelDrawingArea.frame) else {
            line.strokeColor = .black
            panelDrawingArea.fillColor = .white
            return nil
        }
        line.strokeColor = .black
        panelDrawingArea.fillColor = .white
        return texture.cgImage()
    }

    func makePrediction(from cgImage: CGImage) throws -> [String] {
        let classifier = try ValidatorModel(configuration: .init())
        let predictions = try classifier.prediction(input: .init(imageWith: cgImage))
            .classLabelProbs
            .max(count: 2, sortedBy: { $0.value > $1.value })
        return predictions.map(\.key)
    }
}
