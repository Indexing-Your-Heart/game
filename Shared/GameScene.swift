//
//  GameSceneView.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/1/22.
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

class GameScene: SKScene {
    fileprivate var label: SKLabelNode?
    fileprivate var spinnyNode: SKShapeNode?

    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }

        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill

        return scene
    }

    func setUpScene() {
        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = label {
            label.alpha = 0.0
            label.text = NSLocalizedString("example.hello_world", comment: "Hello, world!")
            label.fontName = "Salmon Serif 9 Bold"
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Create shape node to use during mouse interaction
        let width = (size.width + size.height) * 0.05
        spinnyNode = SKShapeNode(rectOf: CGSize(width: width, height: width), cornerRadius: width * 0.3)

        if let spinnyNode = spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
            ]))
        }
    }

    override func didMove(to _: SKView) {
        setUpScene()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = spinnyNode?.copy() as? SKShapeNode {
            spinny.position = pos
            spinny.strokeColor = color
            addChild(spinny)
        }
    }

    override func update(_: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let label = label {
            label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
        }

        for touch in touches {
            makeSpinny(at: touch.location(in: self), color: SKColor.green)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            makeSpinny(at: touch.location(in: self), color: SKColor.blue)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            makeSpinny(at: touch.location(in: self), color: SKColor.red)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            makeSpinny(at: touch.location(in: self), color: SKColor.red)
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func mouseDown(with event: NSEvent) {
        if let label = label {
            label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
        }
        makeSpinny(at: event.location(in: self), color: SKColor.green)
    }

    override func mouseDragged(with event: NSEvent) {
        makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }

    override func mouseUp(with event: NSEvent) {
        makeSpinny(at: event.location(in: self), color: SKColor.red)
    }
}
#endif
