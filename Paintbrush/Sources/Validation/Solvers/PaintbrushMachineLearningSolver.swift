//
//  PaintbrushMachineLearningSolver.swift
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
import SpriteKit
import UniformTypeIdentifiers

/// A protocol that indicates a class is capable of making predictions from player drawings.
public protocol PaintbrushMachineLearningSolver: PaintbrushSolver where PaintbrushInput == CGImage,
    PaintbrushOutput == [String]
{
    /// Returns a portion of the screen from the ``panelDrawingArea`` as as CGImage.
    func getCanvasImageFromScene() -> CGImage?

    /// Returns whether the puzzle's predictions line up with the expected puzzle solution.
    /// - Parameter puzzle: The puzzle that the predictions should have.
    /// - Parameter predictions: The list of likely predictions from the validator model.
    func predictionMatches(puzzle: PaintbrushStagePuzzleConfiguration, in predictions: [String]) -> Bool
}

// MARK: - Default Implementations

public extension PaintbrushMachineLearningSolver {
    private func resizedForModel(image: CGImage) -> CGImage? {
        let newSize = CGSize(width: 299, height: 299)
        guard let colorSpace = image.colorSpace else { return nil }
        guard let ctx = CGContext(
            data: nil,
            width: Int(newSize.width),
            height: Int(newSize.height),
            bitsPerComponent: image.bitsPerComponent,
            bytesPerRow: image.bytesPerRow,
            space: colorSpace,
            bitmapInfo: image.alphaInfo.rawValue
        ) else { return nil }
        ctx.interpolationQuality = .high
        ctx.draw(image, in: CGRect(origin: .zero, size: newSize))
        return ctx.makeImage()
    }

    func createInput(from points: [CGPoint]) -> PaintbrushInput? {
        guard let drawnLine = makePath(from: points) else {
            return nil
        }
        drawingDelegateNode?.addChild(drawnLine)
        return getCanvasImageFromScene()
    }

    func createInputFromPath(in _: SKShapeNode) -> PaintbrushInput? {
        guard let sourceImage = getCanvasImageFromScene() else { return nil }
        return resizedForModel(image: sourceImage)
    }

    func matches(prediction: PaintbrushOutput, against sourceOfTruth: PaintbrushStagePuzzleConfiguration) -> Bool {
        predictionMatches(puzzle: sourceOfTruth, in: prediction)
    }

    func predictionMatches(puzzle: PaintbrushStagePuzzleConfiguration, in predictions: [String]) -> Bool {
        predictions.contains(puzzle.expectedResult)
    }

    func predictDrawing() -> Result<PaintbrushOutput, PaintbrushSolverError> {
        let points = getDrawnPathPoints()
        guard let input = createInput(from: points) else {
            return .failure(.inputCaptureFailure)
        }

        do {
            let prediction = try getPrediction(from: input)
            return .success(prediction)
        } catch {
            return .failure(.predictionFailure(error))
        }
    }
}
