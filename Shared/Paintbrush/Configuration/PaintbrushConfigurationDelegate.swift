//
//  PaintbrushConfigurationDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/22.
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

/// A protocol that indicates a class is capable of loading and configuring a scene with a Paintbrush stage
/// configuration.
protocol PaintbrushConfigurationDelegate: AnyObject {
    /// The stage configuration object that the delegate will read from.
    var stageConfiguration: PaintbrushStageConfiguration? { get set }

    /// The current puzzle in the stage.
    var puzzle: PaintbrushStagePuzzleConfiguration? { get set }

    /// A method called when the puzzle the deleagte will read from is set.
    func didSetPuzzleConfiguration(to puzzleConfig: PaintbrushStagePuzzleConfiguration)

    /// Creates and stores a Paintbrush stage configuration from a resource name.
    func readPuzzleConfiguration(from resourceName: String)
}

extension PaintbrushConfigurationDelegate {
    func readPuzzleConfiguration(from resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            print("Failed to load \(resourceName).json")
            return
        }
        guard let data = try? Data(contentsOf: .init(filePath: path)) else { return }
        let decoder = PaintbrushStageConfiguration.decoder()
        guard let config = try? decoder.decode(PaintbrushStageConfiguration.self, from: data) else {
            return
        }
        stageConfiguration = config
        if let first = config.puzzles.first {
            puzzle = first
            didSetPuzzleConfiguration(to: first)
        }
    }
}
