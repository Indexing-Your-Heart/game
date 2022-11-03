//
//  PaintbrushScene+Inputs.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/29/22.
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

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension PaintbrushScene {
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            panelWillStartDrawing(at: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            panelWillMoveDrawing(to: touch.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if childNode(withName: "//exitButton")?.frame.contains(location) == true {
                dismissIfPresent()
                return
            }
            if let debug = childNode(withName: "debugSprite"), debug.frame.contains(location), !debug.isHidden {
                nextPuzzle()
                return
            }
            panelWillFinishDrawing(at: location)
        }
        if let puzzle, getDrawingPoints()?.isEmpty == false {
            highlight(with: self, matching: puzzle)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            panelWillFinishDrawing(at: touch.location(in: self))
        }
    }
}
#endif

#if os(macOS)
// Mouse-based event handling
extension PaintbrushScene {
    override func mouseDown(with event: NSEvent) {
        panelWillStartDrawing(at: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        panelWillMoveDrawing(to: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        if childNode(withName: "//exitButton")?.frame.contains(location) == true {
            dismissIfPresent()
            return
        }
        if childNode(withName: "debugSprite")?.frame.contains(location) == true {
            nextPuzzle()
            return
        }
        panelWillFinishDrawing(at: event.location(in: self))
        if let puzzle, getDrawingPoints()?.isEmpty == false {
            highlight(with: self, matching: puzzle)
        }
    }
}
#endif
