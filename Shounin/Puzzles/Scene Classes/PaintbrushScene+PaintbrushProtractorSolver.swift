//
//  PaintbrushScene+PaintbrushProtractorSolver.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/3/22.
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
import Paintbrush
import SpriteKit

extension PaintbrushScene: PaintbrushProtractorSolver {
    func makeRecognizer(with input: PaintbrushPointPath) -> PaintbrushRecognizer {
        let recognizer = PaintbrushRecognizer(from: input, accountForOrientation: false, resampledBy: 24)
        recognizer.insertTemplates(reading: "\(name ?? "Stage0")t", in: .main)
        return recognizer
    }

    func getDrawnPathPoints() -> [CGPoint] {
        var points = [CGPoint]()
        if let nodes = getDrawingPoints() {
            let originalPositions = nodes.map(\.position)
            let translated = originalPositions.map { point in
                point.translated(by: panelDrawingArea?.position ?? .zero)
            }
            points.append(contentsOf: translated)
#if DEBUG
            print("Current Drawing (TC): ", points.map { [Int($0.x), Int($0.y)] })
#endif
        }
        return points
    }

    func makePath(from points: [CGPoint]) -> SKShapeNode? {
        let drawnPath = CGMutablePath()
        let reconverted = points.map { point in
            point.translated(
                by:
                .init(
                    x: (panelDrawingArea?.position.x ?? 0) * -1,
                    y: (panelDrawingArea?.position.y ?? 0) * -1
                )
            )
        }
        for points in reconverted.windows(ofCount: 2) {
            guard let current = points.first, let next = points.last else { continue }
            drawnPath.move(to: current)
            drawnPath.addQuadCurve(to: next, control: current)
        }
        getDrawingPoints()?.forEach { $0.removeFromParent() }
        let pathNode = SKShapeNode(
            path: drawnPath,
            stroke: .init(hexString: puzzle?.palette.panelLineColor ?? "#000000")
        )
        pathNode.name = "witPath"
        drawingDelegateNode?.addChild(pathNode)
        return pathNode
    }
}
