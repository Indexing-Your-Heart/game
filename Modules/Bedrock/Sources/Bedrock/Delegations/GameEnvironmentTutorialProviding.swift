//
//  GameEnvironmentTutorialDelegate.swift
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
import SpriteKit

/// A delegate that handles creating and displaying tutorials.
public protocol GameEnvironmentTutorialProviding {
    /// Whether the player has entered solve mode for the first time.
    /// Internally, this is used to determine whether the tutorial for solving a puzzle should be displayed on screen.
    var enteredSolveModeForFirstUse: Bool { get set }

    /// The tutorial node that displays hints on how to move or interact in the world.
    var tutorialNode: SKNode? { get set }

    /// Dismisses the tutorial node and removes it from the scene tree, if present.
    func dismissTutorialNode()

    /// Retrieves the reference node containing the tutorial for movement, or nil if the file cannot be located.
    func getMovementTutorialReferenceNode() -> SKReferenceNode?

    /// Sets a specified node to be the tutorial node.
    /// - Parameter tutorial: The node that will be displayed as a tutorial.
    func setUpTutorialNode(tutorial: SKNode)

    /// Returns whether the tutorial should be displayed.
    func tutorialShouldBeDisplayed() -> Bool
}
