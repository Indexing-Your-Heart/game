//
//  GameEnvironment+Puzzles.swift
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

import SpriteKit
import CranberrySprite
import Paintbrush

extension GameEnvironment {
    /// Returns whether the player is close to a puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func playerIsCloseToPuzzle(tolerance: Int) -> Bool {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return false }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance)
    }

    /// Returns the position of the closest puzzle given a maximum distance tolerance.
    /// - Parameter tolerance: The maximum distance the player can be from the closest puzzle before being considered
    /// out of range.
    func getClosestPuzzlePosition(tolerance: Int) -> CGPoint? {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return nil }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance) ? closestPuzzle : nil
    }

    /// Loads the current puzzle if the player is near a puzzle panel and a puzzle exists for it.
    func loadPuzzleIfPresent() {
        guard let puzzleScene = PaintbrushScene(fileNamed: stageName), let puzzle else { return }
        puzzleScene.scaleMode = scaleMode
        puzzleScene.puzzle = puzzle
        AppDelegate.observedState.previousEnvironment = self
        AppDelegate.observedState.puzzleTriggerName = puzzle.expectedResult
        view?.presentScene(puzzleScene)
    }

    /// Loads the puzzle that is closest to the player.
    func loadClosestPuzzleToPlayer() {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: compareDistanceToPlayer) else { return }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        let puzzleIdx = allPuzzleTriggers.firstIndex(of: closestPuzzle)
        if distanceFromPlayer <= 32, let idx = puzzleIdx {
            if puzzleIdx == allPuzzleTriggers.firstIndex(of: metapuzzleTrigger) {
                guard let metaConfig = stageConfiguration?.metapuzzle else { return }
                let metapuzzle = PaintbrushStagePuzzleConfiguration(
                    paintingName: "",
                    expectedResult: metaConfig.expectedResult,
                    palette: metaConfig.palette
                )
                puzzle = metapuzzle
            } else {
                puzzle = stageConfiguration?.puzzles.first { $0.expectedResult == puzzleFlow[idx] }
            }
            enteredSolveModeForFirstUse = true
            loadPuzzleIfPresent()
        }
    }
}
