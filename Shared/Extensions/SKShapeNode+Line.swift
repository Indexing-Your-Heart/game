//
//  SKShapeNode+Line.swift
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

public extension SKShapeNode {
    /// Creates a shape node following a path with a specified stroke color.
    /// - Parameter path: The Core Graphics path that will be used.
    /// - Parameter stroke: The stroke color of the path that will be used.
    convenience init(path: CGPath, stroke: SKColor) {
        self.init(path: path)
        lineJoin = .round
        lineCap = .round
        lineWidth = 16
        strokeColor = stroke
    }
}
