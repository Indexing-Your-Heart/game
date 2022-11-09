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
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            guard let player else { return }
            let location = touch.location(in: self)
            let derivedMoveTime = location.distance(player.position) / 64

            player.runSequence {
                SKAction.run { [weak self] in
                    self?.dismissTutorialNode()
                }
                SKAction.move(to: touch.location(in: self), duration: TimeInterval(derivedMoveTime))
                SKAction.run { [weak self] in
                    self?.displaySolvingTutorialIfNeeded()
                    self?.loadClosestPuzzleToPlayer()
                }
            }
        }
    }
}
#endif

#if os(macOS)
extension GameEnvironment {
    override func keyDown(with event: NSEvent) {
        guard let player else { return }
        switch event.keyCode {
        // Move up.
        case 0x0D, 0x7E:
            player.run(.moveBy(x: 0, y: 32, duration: 0.1))
        // Move left.
        case 0x00, 0x7B:
            player.run(.moveBy(x: -32, y: 0, duration: 0.1))
        // Move down.
        case 0x01, 0x7D:
            player.run(.moveBy(x: 0, y: -32, duration: 0.1))
        // Move right.
        case 0x02, 0x7C:
            player.run(.moveBy(x: 32, y: 0, duration: 0.1))
        // Invoke solve mode.
        case 0x31:
            loadClosestPuzzleToPlayer()
        default:
            print(event.keyCode)
        }
        dismissTutorialNode()
    }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        displaySolvingTutorialIfNeeded()
    }
}

#endif
