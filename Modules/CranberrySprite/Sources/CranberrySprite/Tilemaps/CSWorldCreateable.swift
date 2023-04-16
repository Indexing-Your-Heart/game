//
//  CSWorldCreateable.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import SpriteKit

/// A protocol that indicates a SpriteKit scene or node contains a world represented by a tile map.
public protocol CSWorldCreateable {
    /// The world as a tile map or something that can be parsed like a tile map.
    var world: CSTileMapParseable? { get set }

    /// Generates the world by parsing the tile map.
    func generateWorld()

    /// Perform operations on a given tile map definition, usually to create a new sprite node.
    /// - Parameter definition: The tile map definition at the current spot in the tile map.
    func applyOnTile(from definition: CSTileMapDefinition)
}

public extension CSWorldCreateable {
    func generateWorld() {
        guard let world = world else { return }
        world.parseTilemap(applicator: applyOnTile)
    }
}
