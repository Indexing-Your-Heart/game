//
//  GameEnvironmentPuzzleDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/15/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
//

import CranberrySprite
import Paintbrush
import SpriteKit

/// A delegate that handles configuring and loading Paintbrush puzzles.
public protocol GameEnvironmentPuzzleDelegate: AnyObject {
    /// An array of points where puzzle triggers are located.
    var puzzleTriggers: [CGPoint] { get set }

    /// The position of the metapuzzle trigger.
    var metapuzzleTrigger: CGPoint { get set }

    /// The Paintbrush stage configuration that corresponds to this level.
    var stageConfiguration: PaintbrushStageConfiguration? { get set }

    /// Returns whether the player is close to a puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func playerIsCloseToPuzzle(tolerance: Int) -> Bool

    /// Returns the position of the closest puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func getClosestPuzzlePosition(tolerance: Int) -> CGPoint?

    /// Loads the current puzzle if the player is near a puzzle panel and a puzzle exists for it.
    func loadPuzzleIfPresent()

    /// Loads the puzzle that is closest to the player.
    func loadClosestPuzzleToPlayer()
}

public extension GameEnvironmentPuzzleDelegate {
    /// Returns an array of all puzzle triggers in the level, including the metapuzzle.
    func allPuzzleTriggers() -> [CGPoint] {
        puzzleTriggers + [metapuzzleTrigger]
    }
}
