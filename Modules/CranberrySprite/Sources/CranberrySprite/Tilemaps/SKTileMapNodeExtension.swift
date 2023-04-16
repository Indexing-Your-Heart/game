//
//  File.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import SpriteKit

public extension SKTileMapNode {
    /// Performs an operation over the coordinates of the tiles.
    /// - Parameter applicator: A closure that executes for every cell in the tilemap.
    /// - Complexity: Quadratic
    func iterateTiles(applicator: (Int, Int) -> Void) {
        for column in 0 ..< numberOfColumns {
            for row in 0 ..< numberOfRows {
                applicator(column, row)
            }
        }
    }
}
