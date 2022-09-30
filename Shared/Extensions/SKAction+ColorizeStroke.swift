//
//  SKAction+ColorizeStroke.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/22.
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

extension SKAction {
    /// Changes the stroke color of an `SKShapeNode` to a specified color.
    ///
    /// - Parameter color: The color to change the stroke color to.
    /// - Parameter duration: The amount of time to take to perform this action.
    class func colorizeStroke(to color: SKColor, duration: TimeInterval) -> SKAction {
        .customAction(withDuration: duration) { node, lerp in
            guard let shapeNode = node as? SKShapeNode else { return }
            if let blendedColor = shapeNode.strokeColor.blended(withFraction: lerp, of: color) {
                shapeNode.strokeColor = blendedColor
            }
        }
    }
}
