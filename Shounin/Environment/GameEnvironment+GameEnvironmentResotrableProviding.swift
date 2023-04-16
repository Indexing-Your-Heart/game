//
//  GameEnvironment+GameEnvironmentResotrableProviding.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 4/1/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Celestia
import SpriteKit

extension GameEnvironment: CelestialContextProviding {
    typealias State = GameEnvironmentRestorable
    func capture() -> GameEnvironmentRestorable {
        GameEnvironmentRestorable(
            stageName: stageName,
            playerPosition: player?.position ?? .zero,
            solvedPuzzles: Array(solvedPuzzles),
            displayedTutorial: displayedMovementTutorial,
            linkedStory: completionCaslonName
        )
    }

    func restore(from state: GameEnvironmentRestorable) {
        guard state.stageName == stageName else { return }
        state.solvedPuzzles.forEach { self.solvedPuzzles.insert($0) }
        player?.position = state.playerPosition
        setEndingScene(to: state.linkedStory)
        if state.displayedTutorial {
            tutorialNode?.removeFromParent()
            tutorialNode = nil
        }
    }
}
