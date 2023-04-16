//
//  CSTileMapParseable.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import SpriteKit

/// A protocol that defines a node can parse a tile map.
public protocol CSTileMapParseable {
    /// Parse through the tilemap, running an applicator closure on every available tile.
    /// - Parameter applicator: An escaping closure that executes on available tiles as ``CSTileMapDefinition``.
    func parseTilemap(applicator: @escaping (CSTileMapDefinition) -> Void)
}

extension SKTileMapNode: CSTileMapParseable {
    public func parseTilemap(applicator: @escaping (CSTileMapDefinition) -> Void) {
        let halfWidth = CGFloat(numberOfColumns) / (tileSize.width * 2)
        let halfHeight = CGFloat(numberOfRows) / (tileSize.height * 2)

        iterateTiles { column, row in
            guard let tileMapDefinition = tileDefinition(atColumn: column, row: row) else { return }
            let spritePositionX = CGFloat(column) * self.tileSize.width - halfWidth + (self.tileSize.width / 2)
            let spritePositionY = CGFloat(row) * self.tileSize.height - halfHeight + (self.tileSize.height / 2)

            let spriteNode = SKSpriteNode(texture: tileMapDefinition.textures[0])
            spriteNode.zPosition = 1
            spriteNode.isHidden = false

            spriteNode.position = CGPoint(
                x: spritePositionX + self.position.x,
                y: spritePositionY + self.position.y
            )

            let definiton = CSTileMapDefinition(
                skDefinition: tileMapDefinition,
                position: .init(x: column, y: row),
                unitSize: self.tileSize,
                sprite: spriteNode,
                texture: tileMapDefinition.textures[0]
            )
            applicator(definiton)
        }
    }
}
