//
//  GameEnvironmentNavigationDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/14/22.
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
import SKTiled
import GameplayKit

public protocol GameEnvironmentNavigationDelegate: AnyObject {
    var walkableTiles: [SKTile] { get set }
    var walkingLayer: SKTileLayer? { get set }
    func getWalkableNodes(from layer: SKTileLayer)
    func path(to coordinate: CGPoint) -> [GKGraphNode]
    func actions(with graphNodes: [GKGraphNode]) -> [SKAction]
}
