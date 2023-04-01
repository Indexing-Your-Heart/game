//
//  GameEnvironment+SKTilemapDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 4/1/23.
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
import SKTiled

extension GameEnvironment: SKTilemapDelegate {
    func didRenderMap(_ tilemap: SKTilemap) {
        tilemap.layers.map { $0 as? SKTileLayer }
            .forEach { layer in
                if let layer { configureLayer(layer, in: tilemap) }
            }
    }
}
