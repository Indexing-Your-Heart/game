//
//  CaslonSceneRefreshDelegate.swift
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

// MARK: - Timeline Delegation

extension CaslonScene: CaslonSceneTimelineDelegate {
    func willDisplayNewEvent(event: JensonEvent) {
        dismissTutorialNode()
        switch event.type {
        case .refresh:
            if let triggers = event.refresh {
                for trigger in triggers {
                    refreshContents(with: trigger)
                }
            }
        case .dialogue:
            updateDialogue(with: event)
        case .question:
            guard let question = event.question else { return }
            load(question: question)
        default:
            logger.debug("Skipping event type \(event.type.rawValue)\n- Content: \(event.what)")
        }
    }

    func didDisplayNewEvent(event: JensonEvent) {
        let standardEvents: [JensonEvent.EventType] = [.choice, .dialogue, .question]
        guard standardEvents.contains(event.type) else {
            next()
            return
        }
    }

    func didReachEndOfTimeline() {
        runSequence {
            SKAction.fadeOut(withDuration: 1.5)
            SKAction.run {
                AppDelegate.currentFlow.next()
                if AppDelegate.currentFlow.currentBlock == nil {
                    exit(0)
                }
            }
        }
    }
}

// MARK: - Refresh Content Delegation

extension CaslonScene: CaslonSceneRefreshDelegate {
    func willRefreshContents(of kind: JensonRefreshContent.Kind, to resourceName: String, with priority: Int?) {
        switch kind {
        case .image:
            if let layer = childNode(withName: "imgLayer_\(priority ?? 0)") as? SKSpriteNode, !resourceName.isEmpty {
                layer.runSequence {
                    SKAction.fadeAlpha(to: 0, duration: 0.1)
                    SKAction.setTexture(SKTexture(imageNamed: resourceName), resize: false)
                    SKAction.fadeAlpha(to: 1, duration: 0.1)
                }
            } else if let layer = childNode(withName: "imgLayer_\(priority ?? 0)") as? SKSpriteNode {
                logger.debug("Clearing priority layer \(priority ?? 0)")
                layer.runSequence {
                    SKAction.fadeAlpha(to: 0, duration: 0.1)
                    SKAction.run {
                        layer.texture = nil
                    }
                    SKAction.fadeAlpha(to: 1, duration: 0.1)
                }
            } else {
                logger.warning("Priority layer \(priority ?? 0) not found")
            }
        default:
            break
        }
    }

    func didRefreshContents() {}
}

// MARK: - Question Delegate

extension CaslonScene: CaslonSceneQuestionDelegate {
    func willLoadOptions(from question: JensonQuestion) {
        buildChoiceMenu(for: question)
    }

    func didLoadOptions() {
        choiceMenu?.isHidden = false
    }

    func shouldBlockOtherInputs() -> Bool {
        choiceMenu?.isHidden == false
    }

    func selectedOption(at location: CGPoint) -> String? {
        guard let choiceMenu else { return nil }
        let buttonNames = options.map { "choice:\($0.name)" }
        return buttonNames.map {
            choiceMenu.childNode(withName: $0)
        }.filter {
            $0?.frame.contains(location) == true
        }
        .first??.name
    }

    func didSelectOption(with name: String) {
        guard let choice = options.first(where: { $0.name == name }) else { return }
        timeline.insert(contentsOf: choice.events, at: 0)
        choiceMenu?.children.filter { $0.name?.starts(with: "choice") == true }
            .forEach { node in
                node.removeFromParent()
            }
        options.removeAll()
        choiceMenu?.isHidden = true
    }
}
