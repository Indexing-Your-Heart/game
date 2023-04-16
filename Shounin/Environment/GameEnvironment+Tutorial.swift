//
//  GameEnvironment+Tutorial.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/16/22.
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
import SpriteKit

extension GameEnvironment: GameEnvironmentTutorialDelegate {
    func dismissTutorialNode() {
        tutorialNode?.runSequence {
            SKAction.fadeAlpha(to: 0, duration: 0.5)
            SKAction.run { [weak self] in
                self?.tutorialNode?.removeFromParent()
                self?.tutorialNode = nil
            }
        }
    }

    func getMovementTutorialReferenceNode() -> SKReferenceNode? {
#if os(macOS)
        if AppDelegate.currentFlow.currentBlock?.showTutorials == true {
            return SKReferenceNode(fileNamed: "TutorialKeyLayout")
        }
#else
        if AppDelegate.currentFlow.currentBlock?.showTutorials == true {
            return SKReferenceNode(fileNamed: "TutorialTouchLayout")
        }
#endif
        return nil
    }

    func setUpTutorialNode(tutorial: SKNode) {
        tutorial.zPosition += 20
        tutorial.setScale(0.3)
        tutorial.alpha = 0
        tutorialNode = tutorial

        tutorial.apply(recursively: true) { child in
            if let sprite = child as? SKSpriteNode {
                sprite.texture?.configureForPixelArt()
            }
        }
    }

    func tutorialShouldBeDisplayed() -> Bool {
        AppDelegate.currentFlow.currentBlock?.showTutorials == true && !enteredSolveModeForFirstUse
    }
}
