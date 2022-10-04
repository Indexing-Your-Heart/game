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

class CaslonScene: SKScene {
    var timeline = [JensonEvent]()
    var whatLabel: SKLabelNode?
    var whoLabel: SKLabelNode?
    var choiceMenu: SKNode?
    var currentOptions = [JensonChoice]()

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        whatLabel = childNode(withName: "//whatLabel") as? SKLabelNode
        whoLabel = childNode(withName: "//whoLabel") as? SKLabelNode
        choiceMenu = childNode(withName: "//menu")
        choiceMenu?.isHidden = true
        choiceMenu?.childNode(withName: "templateButton")?.isHidden = true
        if let templateButtonText = choiceMenu?.childNode(withName: "templateButton")?
            .childNode(withName: "buttonText") as? SKLabelNode {
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

    func loadScript(named scriptName: String) {
        guard let path = Bundle.main.path(forResource: scriptName, ofType: "jenson") else { return }
        let reader = try? JensonReader(fileURLWithPath: path)
        if let file = try? reader?.decode() {
            timeline = file.timeline
        }
        runSequence {
            SKAction.wait(forDuration: 1.5)
            SKAction.run { [weak self] in
                self?.next()
            }
            SKAction.run(.fadeAlpha(to: 1, duration: 0.5), onChildWithName: "whoLabel")
            SKAction.run(.fadeAlpha(to: 1, duration: 0.5), onChildWithName: "whatLabel")
        }

    }
}

extension CaslonScene: CaslonSceneTimelineDelegate {
    func willDisplayNewEvent(event: JensonEvent) {
        switch event.type {
        case .refresh:
            if let triggers = event.refresh {
                for trigger in triggers {
                    refreshContents(with: trigger)
                }
            }
        case .dialogue:
            if let whatLabel {
                whatLabel.text = event.what
                    .replacingOccurrences(
                        of: "[Player]",
                        with: NSFullUserName().split(separator: " ").first ?? "Player"
                    )
            }
            if let whoLabel {
                whoLabel.text = event.who
                    .replacingOccurrences(
                        of: "Player",
                        with: NSFullUserName().split(separator: " ").first ?? "Player"
                    )
            }
        case .question:
            choiceMenu?.isHidden = false
            if let whatLabel, let question = event.question {
                if !question.question.isEmpty {
                    whatLabel.text = question.question
                }
                currentOptions = question.options
                print(currentOptions)
                let approximatedHeight = question.options.count * (56 + 24)
                var yOffset = 0 - (approximatedHeight / 4)
                for choice in question.options {
                    guard let template = choiceMenu?.childNode(withName: "templateButton") else { continue }
                    guard let copy = template.copy() as? SKSpriteNode else { continue }
                    copy.isHidden = false
                    copy.position.y = CGFloat(yOffset)
                    if let textContent = copy.childNode(withName: "buttonText") as? SKLabelNode {
                        textContent.text = choice.name
                    }
                    choiceMenu?.addChild(copy)
                    yOffset += (56 + 24)
                }
            }
        default:
            break
        }
    }

    func didDisplayNewEvent(event: JensonEvent) {
        guard event.type != .comment else {
            next()
            return
        }
    }
}

extension CaslonScene: CaslonSceneRefreshDelegate {
    func willRefreshContents(of kind: JensonRefreshContent.Kind, to resourceName: String, with priority: Int?) {
        switch kind {
        case .image:
            if let layer = childNode(withName: "imgLayer_\(priority ?? 0)") as? SKSpriteNode {
                layer.texture = SKTexture(imageNamed: resourceName)
            }
        default:
            // TODO: Implement for non-image cases
            break
        }
    }

    func didRefreshContents(of kind: JensonRefreshContent.Kind, to resourceName: String, with priority: Int?) {

    }
}
