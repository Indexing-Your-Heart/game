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

import SpriteKit

extension GameEnvironment: GameEnvironmentRestorableProviding {
    func capture() -> GameEnvironmentRestorable {
        return GameEnvironmentRestorable(
            stageName: self.stageName,
            playerPosition: self.player?.position ?? .zero,
            solvedPuzzles: Array(self.solvedPuzzles),
            displayedTutorial: displayedMovementTutorial,
            linkedStory: completionCaslonName
        )
    }

    func restore(from restoredState: GameEnvironmentRestorable) {
        guard restoredState.stageName == self.stageName else { return }
        restoredState.solvedPuzzles.forEach { self.solvedPuzzles.insert($0) }
        self.player?.position = restoredState.playerPosition
        self.setEndingScene(to: restoredState.linkedStory)
        if restoredState.displayedTutorial {
            self.tutorialNode?.removeFromParent()
            self.tutorialNode = nil
        }
    }
}
