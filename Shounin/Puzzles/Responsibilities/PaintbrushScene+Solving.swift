//
//  PaintbrushScene+Solving.swift
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

import Foundation
import Paintbrush
import SpriteKit

// MARK: - Puzzle Configuration

extension PaintbrushScene: PaintbrushConfigurationDelegate {
    func didSetPuzzleConfiguration(to puzzleConfig: PaintbrushStagePuzzleConfiguration) {
        guard let panelDrawingArea, let painting else { return }
        panelDrawingArea.fillColor = SKColor(hexString: puzzleConfig.palette.panelColor)
        if puzzleConfig.paintingName.isEmpty {
            painting.isHidden = true
            panelDrawingArea.position = .zero
            childNode(withName: "//solveOverlay")?.position = .zero
        }
        painting.texture = .init(imageNamed: puzzleConfig.paintingName)
        painting.configureForPixelArt()

        let tutorialOverlay = drawingDelegateNode?.childNode(withName: "tutorialOverlay") as? SKSpriteNode

        if let overlayName = puzzleConfig.tutorialOverlay, let overlay = tutorialOverlay {
            overlay.texture = SKTexture(imageNamed: overlayName)
            if puzzleConfig.paintingName.isEmpty {
                overlay.position = .zero
            }
        } else {
            drawingDelegateNode?.childNode(withName: "tutorialOverlay")?.removeFromParent()
        }
    }
}

// MARK: - Panel Interactions

extension PaintbrushScene: PanelInteractionDelegate {
    func panelWillStartDrawing(at location: CGPoint) {
        guard let panelDrawingArea, panelDrawingArea.frame.contains(location) else { return }
        createDrawingNode(at: location)
        if let audioCue = childNode(withName: "sndStart") as? SKAudioNode {
            audioCue.play()
        }
        childNode(withName: "//solveOverlay")?.isHidden = true
        showingTutorialHint = false
    }

    func panelWillMoveDrawing(to location: CGPoint) {
        createDrawingNode(at: location)
    }

    func panelWillFinishDrawing(at location: CGPoint) {
        createDrawingNode(at: location)
    }

    func panelWillHighlight(onPredictionStatus prediction: Bool) {
        solveState = prediction ? .solved : .failure
        guard let path = drawingDelegateNode?.childNode(withName: "witPath") as? SKShapeNode else { return }
        path.zPosition = 5
        if prediction {
            path.strokeColor = SKColor(hexString: puzzle?.palette.panelLineColor ?? "#000000")
            return
        }
    }

    func panelDidHighlight(onPredictionStatus prediction: Bool) {
        guard let path = drawingDelegateNode?.childNode(withName: "witPath") as? SKShapeNode else { return }
        let pathColor = path.strokeColor.blended(withFraction: 0.7, of: .black) ?? path.strokeColor
        if prediction {
            if let audioCue = childNode(withName: "sndSuccess") as? SKAudioNode {
                audioCue.play()
            }
            return
        }

        path.runSequence {
            SKAction.run { [weak self] in
                if let audioCue = self?.childNode(withName: "sndFail") as? SKAudioNode {
                    audioCue.play()
                }
            }
            SKAction.repeat(
                .sequence([
                    .colorizeStroke(to: .red, duration: 0.5),
                    .colorizeStroke(to: pathColor, duration: 0.5)
                ]),
                count: 5
            )
            SKAction.fadeOut(withDuration: 5.0)
        } completion: {
            path.removeFromParent()
        }
    }
}
