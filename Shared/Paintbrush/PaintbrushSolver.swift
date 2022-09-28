//
//  PaintbrushSolver.swift
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

import Foundation
import SpriteKit

/// An enumeration representing errors that may be thrown during prediction.
enum PaintbrushSolverError: Error {
    /// The path couldn't be generated from the player's drawing.
    case noPathGenerated

    /// The scene couldn't capture the area for the prediction.
    case imageCaptureFailure

    /// An error occurred during the prediction phase.
    case predictionFailure(Error)
}

/// A protocol that indicates a class is capable of making predictions from player drawings.
protocol PaintbrushSolver: AnyObject {
    /// The shape node that represents the visible drawing area; i.e., the puzzle panel.
    var panelDrawingArea: SKShapeNode? { get set }

    /// The node that represents the underlying drawing area.
    var drawingDelegateNode: SKNode? { get set }

    /// Creates a shape node with a CGPath based on the player's drawing.
    func makePathFromChildren() -> SKShapeNode?

    /// Returns a portion of the screen from the ``panelDrawingArea`` as as CGImage.
    func getCanvasImageFromScene() -> CGImage?

    /// Attempts to make a prediction from the validation model.
    /// - Throws: Prediction errors may be thrown from the ``ValidatorModel``.
    /// - Returns: An array of strings of the most likely candidates.
    func makePrediction(from cgImage: CGImage) throws -> [String]

    /// Predicts the player's current drawing and returns likely candidates, or a failure if an error occurred.
    func predictDrawing() -> Result<[String], PaintbrushSolverError>
}

extension PaintbrushSolver {
    func predictDrawing() -> Result<[String], PaintbrushSolverError> {
        guard let drawnLine = makePathFromChildren() else {
            return .failure(.noPathGenerated)
        }
        drawingDelegateNode?.addChild(drawnLine)
        guard let image = getCanvasImageFromScene() else {
            return .failure(.imageCaptureFailure)
        }
        do {
            let prediction = try makePrediction(from: image)
            return .success(prediction)
        } catch {
            return .failure(.predictionFailure(error))
        }
    }
}
