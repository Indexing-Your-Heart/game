//
//  CaslonScene+Inputs.swift
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

import SpriteKit

#if os(iOS) || os(tvOS)
extension CaslonScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if inTransition { return }
        for touch in touches {
            let location = touch.location(in: self)
            if let selectedOption = selectedOption(at: location) {
                selectOption(named: selectedOption)
            }
            if shouldBlockOtherInputs() { return }
            next()
        }
    }
}
#endif

#if os(macOS)
extension CaslonScene {
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        if inTransition { return }
        let location = event.location(in: self)
        if let selectedOption = selectedOption(at: location) {
            selectOption(named: selectedOption)
        }
        if shouldBlockOtherInputs() { return }
        next()
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if inTransition { return }
            let location = event.location(in: self)
            if let selectedOption = selectedOption(at: location) {
                selectOption(named: selectedOption)
            }
            if shouldBlockOtherInputs() { return }
            next()
        default:
            break
        }
    }
}
#endif
