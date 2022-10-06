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
import UniformTypeIdentifiers

/// An enumeration representing errors that may be thrown during prediction.
public enum PaintbrushSolverError: Error {
    /// The path couldn't be generated from the player's drawing.
    case noPathGenerated

    /// The scene couldn't capture the area for the prediction.
    case imageCaptureFailure

    /// An error occurred during the prediction phase.
    case predictionFailure(Error)
}

/// An enumeration representing various solve states.
public enum PaintbrushSolveState {
    /// The puzzle hasn't been solved yet, and no attempt was made.
    case unsolved

    /// The puzzle returned a failed state.
    case failure

    /// The puzzle has been solved.
    case solved
}

/// A protocol that indicates a class is capable of making predictions from player drawings.
public protocol PaintbrushSolver: AnyObject {
    /// The shape node that represents the visible drawing area; i.e., the puzzle panel.
    var panelDrawingArea: SKShapeNode? { get set }

    /// The node that represents the underlying drawing area.
    var drawingDelegateNode: SKNode? { get set }

    /// The current state of the puzzle.
    var solveState: PaintbrushSolveState { get set }

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

    /// Returns whether the puzzle's predictions line up with the expected puzzle solution.
    /// - Parameter puzzle: The puzzle that the predictions should have.
    /// - Parameter predictions: The list of likely predictions from the validator model.
    func predictionMatches(puzzle: PaintbrushStagePuzzleConfiguration, in predictions: [String]) -> Bool
}

// MARK: - Default Implementations

public extension PaintbrushSolver {
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

    func predictDrawing() -> Result<[String], PaintbrushSolverError> {
        guard let drawnLine = makePathFromChildren() else {
            return .failure(.noPathGenerated)
        }
        drawingDelegateNode?.addChild(drawnLine)
        guard let sourceImage = getCanvasImageFromScene(), let image = resizedForModel(image: sourceImage) else {
            return .failure(.imageCaptureFailure)
        }

#if os(iOS)
//        if let record = Bundle.main.paintbrushRecordOutput, record {
//            if let mlImage = image.resized(to: .init(width: 47, height: 47)) {
//                mlImage.write(to: "drawing_" + Date.now.formatted(.iso8601))
//            }
//        }
#endif

        do {
            let prediction = try makePrediction(from: image)
            return .success(prediction)
        } catch {
            return .failure(.predictionFailure(error))
        }
    }

    func predictionMatches(puzzle: PaintbrushStagePuzzleConfiguration, in predictions: [String]) -> Bool {
        predictions.contains(puzzle.expectedResult)
    }
}
