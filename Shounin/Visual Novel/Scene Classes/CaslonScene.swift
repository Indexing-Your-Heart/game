//
//  CaslonScene.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/4/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Caslon
import JensonKit
import SpriteKit

/// A SpriteKit scene that can display a Jenson timeline.
class CaslonScene: SKScene {
    var timeline = [JensonEvent]()

    /// The label node that contains the "who" field.
    var whatLabel: SKLabelNode?

    /// The label node that contains the "what" field.
    var whoLabel: SKLabelNode?

    /// The node that houses the choice menu buttons.
    var choiceMenu: SKNode?
    var options = [JensonChoice]()

    /// Whether the scene is undergoing a transition. Defaults to false.
    var inTransition = false

    private var didSetTutorial = false

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        childNode(withName: "//tutorialNodeTap")?.isHidden = true
        whatLabel = childNode(withName: "//whatLabel") as? SKLabelNode
        whoLabel = childNode(withName: "//whoLabel") as? SKLabelNode
        choiceMenu = childNode(withName: "//menu")
        choiceMenu?.isHidden = true
        choiceMenu?.childNode(withName: "templateButton")?.isHidden = true
        if let templateButtonText = choiceMenu?.childNode(withName: "templateButton")?
            .childNode(withName: "buttonText") as? SKLabelNode
        { // swiftlint:disable:this opening_brace
            templateButtonText.fontName = "Salmon Sans 9 Regular"
        }
        if let whatLabel {
            whatLabel.fontName = "Salmon Serif 9 Regular"
            whatLabel.text = ""
            whatLabel.alpha = 0
        }
        if let whoLabel {
            whoLabel.fontName = "Salmon Serif 9 Bold"
            whoLabel.text = ""
            whoLabel.alpha = 0
        }
    }

    /// Loads a script from a Jenson timeline with a given name.
    /// - Parameter scriptName: The name of the Jenson file that will be loaded into this scene.
    func loadScript(named scriptName: String) {
        guard let path = Bundle.main.path(forResource: scriptName, ofType: "jenson") else { return }
        let reader = try? JensonReader(fileURLWithPath: path)
        if let file = try? reader?.decode() {
            timeline = file.timeline
        }
        runSequence {
            SKAction.run { [weak self] in
                self?.inTransition = true
            }
            SKAction.wait(forDuration: 1.5)
            SKAction.run { [weak self] in
                self?.next()
            }
            SKAction.run(.fadeAlpha(to: 1, duration: 0.5), onChildWithName: "whoLabel")
            SKAction.run(.fadeAlpha(to: 1, duration: 0.5), onChildWithName: "whatLabel")
            SKAction.run { [weak self] in
                self?.inTransition = false
                self?.setUpTutorialContext()
            }
        }
    }

    /// Updates the dialogue box with the new dialogue from an event.
    ///
    /// Instances of `Player` and `[Player]` are replaced with the player's full name from the system.
    /// - Parameter event: The event that the dialogue box will display.
    func updateDialogue(with event: JensonEvent) {
        guard let whatLabel, let whoLabel else { return }
        whatLabel.text = event.what
            .replacingOccurrences(
                of: "[Player]",
                with: NSFullUserName().split(separator: " ").first ?? "Player"
            )
        whoLabel.text = event.who
            .replacingOccurrences(
                of: "Player",
                with: NSFullUserName().split(separator: " ").first ?? "Player"
            )
    }

    /// Creates the choice menu for a specified question to let the player make a choice.
    /// - Parameter question: The question the menu will build a choice for.
    func buildChoiceMenu(for question: JensonQuestion) {
        guard let whatLabel else { return }
        if !question.question.isEmpty {
            whatLabel.text = question.question
        }
        options = question.options
        let approximatedHeight = question.options.count * (56 + 24)
        var yOffset = 0 - (approximatedHeight / 4)
        for choice in question.options {
            guard let template = choiceMenu?.childNode(withName: "templateButton") else { continue }
            guard let copy = template.copy() as? SKSpriteNode else { continue }
            copy.name = "choice:\(choice.name)"
            copy.isHidden = false
            copy.position.y = CGFloat(yOffset)
            if let textContent = copy.childNode(withName: "buttonText") as? SKLabelNode {
                textContent.text = choice.name
            }
            choiceMenu?.addChild(copy)
            yOffset += (56 + 24)
        }
    }

    func dismissTutorialNode() {
        guard let tutorialNode = childNode(withName: "//tutorialNodeTap"), didSetTutorial else {
            return
        }
        tutorialNode.runSequence {
            SKAction.fadeAlpha(to: 0, duration: 0.25)
            SKAction.run {
                tutorialNode.removeFromParent()
            }
        }
    }

    private func setUpTutorialContext() {
        guard let tutorialNode = childNode(withName: "//tutorialNodeTap") as? SKSpriteNode else { return }
        if AppDelegate.currentFlow.currentBlock?.showTutorials != true {
            tutorialNode.removeFromParent()
            return
        }
        tutorialNode.isHidden = false
#if os(iOS)
        tutorialNode.texture = SKTexture(imageNamed: "UI_Tap")
#endif
        tutorialNode.texture?.configureForPixelArt()
        didSetTutorial = true
    }
}
