//
//  GameEnvironment.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/5/22.
//

import SpriteKit
import SKTiled

class GameEnvironment: SKScene {
    var tilemap: SKTilemap?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if let tilemap = SKTilemap.load(tmxFile: "Stage1.tmx") {
            self.tilemap = tilemap
            addChild(tilemap)
        }
    }
}
