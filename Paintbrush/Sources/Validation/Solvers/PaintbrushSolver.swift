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
    case inputCaptureFailure

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
    /// An associated type that represents the input data.
    associatedtype PaintbrushInput

    /// An associated type that represents the output data.
    associatedtype PaintbrushOutput

    /// The shape node that represents the visible drawing area; i.e., the puzzle panel.
    var panelDrawingArea: SKShapeNode? { get set }

    /// The node that represents the underlying drawing area.
    var drawingDelegateNode: SKNode? { get set }

    /// The current state of the puzzle.
    var solveState: PaintbrushSolveState { get set }

    /// Retrieves the points in the path.
    func getDrawnPathPoints() -> [CGPoint]

    /// Creates a shape node with a CGPath based on the player's drawing.
    func makePath(from points: [CGPoint]) -> SKShapeNode?

    /// Transforms the given shape node into an input.
    func createInput(from points: [CGPoint]) -> PaintbrushInput?

    /// Generates a prediction from the specified input.
    func getPrediction(from input: PaintbrushInput) throws -> PaintbrushOutput

    func predictDrawing() -> Result<PaintbrushOutput, PaintbrushSolverError>

    func matches(prediction: PaintbrushOutput, against sourceOfTruth: PaintbrushStagePuzzleConfiguration) -> Bool
}
