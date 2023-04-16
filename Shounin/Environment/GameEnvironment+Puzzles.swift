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

import Bedrock
import CranberrySprite
import Paintbrush
import SpriteKit

extension GameEnvironment: GameEnvironmentPuzzleDelegate {
    func getClosestPuzzlePosition(tolerance: Int) -> CGPoint? {
        guard let player else { return nil }
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let closestPuzzle = allPuzzleTriggers.min(by: player.compareDistancesToPoints) else { return nil }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance) ? closestPuzzle : nil
    }

    func loadClosestPuzzleToPlayer() {
        guard let player, let closestPuzzle = allPuzzleTriggers().min(by: player.compareDistancesToPoints) else {
            return
        }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        let puzzleIdx = allPuzzleTriggers().firstIndex(of: closestPuzzle)
        if distanceFromPlayer <= 32, let idx = puzzleIdx {
            if puzzleIdx == allPuzzleTriggers().firstIndex(of: metapuzzleTrigger) {
                guard let metaConfig = stageConfiguration?.metapuzzle else { return }
                let metapuzzle = PaintbrushStagePuzzleConfiguration(
                    paintingName: "",
                    expectedResult: metaConfig.expectedResult,
                    palette: metaConfig.palette,
                    overlay: metaConfig.tutorialOverlay
                )
                puzzle = metapuzzle
            } else {
                puzzle = stageConfiguration?.puzzles.first { $0.expectedResult == puzzleFlow[idx] }
            }
            enteredSolveModeForFirstUse = true
            loadPuzzleIfPresent()
        }
    }

    func loadPuzzleIfPresent() {
        guard let puzzleScene = PaintbrushScene(fileNamed: stageName), let puzzle else { return }
        puzzleScene.scaleMode = scaleMode
        puzzleScene.puzzle = puzzle
        AppDelegate.observedState.previousEnvironment = capture()
        AppDelegate.observedState.puzzleTriggerName = puzzle.expectedResult
        if let view { willMove(from: view) }
        view?.presentScene(puzzleScene, transition: .push(with: .down, duration: 0.5))
    }

    func playerIsCloseToPuzzle(tolerance: Int) -> Bool {
        let allPuzzleTriggers = puzzleTriggers + [metapuzzleTrigger]
        guard let player, let closestPuzzle = allPuzzleTriggers.min(by: player.compareDistancesToPoints) else {
            return false
        }
        let distanceFromPlayer = closestPuzzle.manhattanDistance(to: player.position)
        return distanceFromPlayer <= CGFloat(tolerance)
    }
}

extension GameEnvironment: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to _: Paintbrush.PaintbrushStagePuzzleConfiguration) {}
}
