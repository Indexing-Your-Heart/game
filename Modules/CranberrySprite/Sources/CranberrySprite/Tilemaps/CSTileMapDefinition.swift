//
//  CSTileMapDefinition.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import SpriteKit

/// A structure that contains information about a tile in a tile map parseable node.
public struct CSTileMapDefinition {
    /// The SpriteKit tile definition at the specified position.
    public let skDefinition: SKTileDefinition

    /// A CGPoint representing the column and row the tile exists in the space of tile map.
    public let position: CGPoint

    /// The size of a single unit in the tile map.
    public let unitSize: CGSize

    /// The sprite node that will be generated for this tile.
    public let sprite: SKSpriteNode

    /// The texture that will be used for the resulting sprite.
    public let texture: SKTexture
}

extension CSTileMapDefinition: Equatable {}
