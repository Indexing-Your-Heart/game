//
//  PaintbrushProtractorSolver.swift
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

public protocol PaintbrushProtractorSolver: PaintbrushSolver where PaintbrushInput == PaintbrushPointPath,
    PaintbrushOutput == String
{
    func makeRecognizer(with input: PaintbrushInput) -> PaintbrushRecognizer
}

public extension PaintbrushProtractorSolver {
    func createInput(from points: [CGPoint]) -> PaintbrushInput? {
        let transformedPoints = points.map { PaintbrushPoint(from: $0) }
        return PaintbrushPointPath(points: transformedPoints)
    }

    func getPrediction(from input: PaintbrushInput) throws -> PaintbrushOutput {
        let recognizer = makeRecognizer(with: input)
        let (name, _) = recognizer.recognize()
        print("===\(name)===")
        return name
    }

    func matches(prediction: PaintbrushOutput, against sourceOfTruth: PaintbrushStagePuzzleConfiguration) -> Bool {
        prediction == sourceOfTruth.expectedResult
    }

    func predictDrawing() -> Result<PaintbrushOutput, PaintbrushSolverError> {
        let points = getDrawnPathPoints()
        guard makePath(from: points) != nil else {
            return .failure(.noPathGenerated)
        }
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
