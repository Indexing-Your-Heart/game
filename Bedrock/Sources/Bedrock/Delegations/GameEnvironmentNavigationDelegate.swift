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

import GameplayKit
import SKTiled
import SpriteKit

/// A delegate that handles pathfinding and navigation in a game environment.
public protocol GameEnvironmentNavigationDelegate: AnyObject {
    /// An array of tiles that the player can move around in. This is used to initialize the pathfinding graph.
    var walkableTiles: [SKTile] { get set }

    /// The tilemap layer that contains where walkable tiles are and where the graph will be initialized.
    var walkingLayer: SKTileLayer? { get set }

    /// Retrieves the walkable tiles from a given layer.
    /// - Parameter layer: The layer that contains walkable tiles.
    func getWalkableNodes(from layer: SKTileLayer)

    /// Generates an array of nodes in the pathfinding graph from the player's current position to the destination.
    /// - Parameter coordinate: The destination coordinate for the player to walk to.
    func path(to coordinate: CGPoint) -> [GKGraphNode]

    /// Generates an array of SpriteKit actions from graph nodes for the player to follow.
    /// - Parameter graphNodes: The array of graph nodes to create actions for.
    func actions(with graphNodes: [GKGraphNode], speed: CGFloat) -> [SKAction]
}
