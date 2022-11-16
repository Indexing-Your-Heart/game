//
//  SKPhysicsBody+Immovable.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/15/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
//

import SpriteKit

extension SKPhysicsBody {
    /// Creates an immovable object physics body.
    /// - Parameter size: The size of the physics body's bounds.
    static func immovable(with size: CGSize) -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: size)
        body.affectedByGravity = false
        body.allowsRotation = false
        body.isDynamic = false
        return body
    }
}
