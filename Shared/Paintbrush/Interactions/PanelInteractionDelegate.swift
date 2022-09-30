//
//  PanelInteractionDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/29/22.
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

/// A protocol that indicates a scene handles the drawing of puzzle panels.
protocol PanelInteractionDelegate: AnyObject {
    /// A method called when the player starts drawing on the panel.
    func panelWillStartDrawing(at location: CGPoint)

    /// A method called when the player drags across the panel.
    func panelWillMoveDrawing(to location: CGPoint)

    /// A method called when the player stops drawing on the panel.
    func panelWillFinishDrawing(at location: CGPoint)

    /// A method called when the panel will begin highlighting based on a prediction status.
    func panelWillHighlight(onPredictionStatus prediction: Bool)

    /// A method called when the panel finishes highlighting based on a prediction status.
    func panelDidHighlight(onPredictionStatus prediction: Bool)
}

extension PanelInteractionDelegate {
    /// Highlights the panel after making a prediction.
    /// - Parameter solver: The solver that will make a prediction.
    /// - Parameter puzzle: The puzzle configuration containing the expected result.
    func highlight(with solver: PaintbrushSolver, matching puzzle: PaintbrushStagePuzzleConfiguration) {
        var prediction = false
        let result = solver.predictDrawing()
        switch result {
        case .success(let data):
            prediction = solver.predictionMatches(puzzle: puzzle, in: data)
        case .failure(let error):
#if targetEnvironment(simulator)
            print("WARN: Model predictions not available in simulator.")
            prediction = true
#endif
            print("Error in prediction: \(error.localizedDescription)")
        }
        panelWillHighlight(onPredictionStatus: prediction)
        panelDidHighlight(onPredictionStatus: prediction)
    }
}
