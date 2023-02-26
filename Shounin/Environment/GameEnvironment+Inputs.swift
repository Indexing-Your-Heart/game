//
//  GameEnvironment+Inputs.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/6/22.
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

#if os(iOS)
extension GameEnvironment {
    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let touch = touches.first {
            guard let walkingLayer else { return }
            let location = walkingLayer.coordinateAtTouchLocation(touch)
            let proposedSpeed: CGFloat = 1.0 / CGFloat(touch.tapCount)
            walkToSpecifiedLocation(at: location, speed: proposedSpeed.clamp(to: CGFloat(0.25) ..< CGFloat(1.01)))
        }
    }
}
#endif

#if os(macOS)
extension GameEnvironment {
    override func mouseUp(with event: NSEvent) {
        guard let walkingLayer else { return }
        let location = walkingLayer.coordinateAtMouseEvent(event: event)
        walkToSpecifiedLocation(at: location)
    }

    override func keyDown(with event: NSEvent) {
        guard let player else { return }
        switch event.keyCode {
        // Move up.
        case 0x0D, 0x7E:
            player.runSequence {
                SKAction.run { player.move(in: .up) }
                SKAction.moveBy(x: 0, y: 32, duration: 0.1)
            }
        // Move left.
        case 0x00, 0x7B:
            player.runSequence {
                SKAction.run { player.move(in: .left) }
                SKAction.moveBy(x: -32, y: 0, duration: 0.1)
            }
        // Move down.
        case 0x01, 0x7D:
            player.runSequence {
                SKAction.run { player.move(in: .down) }
                SKAction.moveBy(x: 0, y: -32, duration: 0.1)
            }
        // Move right.
        case 0x02, 0x7C:
            player.runSequence {
                SKAction.run { player.move(in: .right) }
                SKAction.moveBy(x: 32, y: 0, duration: 0.1)
            }
        // Invoke solve mode.
        case 0x31:
            environmentDelegate?.loadClosestPuzzleToPlayer()
        default:
            logger.info("Received keystroke: \(event.keyCode)")
        }
        environmentDelegate?.dismissTutorialNode()
    }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        displaySolvingTutorialIfNeeded()
        player?.run(
            .run { [weak self] in
                self?.player?.stopMoving()
            }
        )
    }
}

#endif
