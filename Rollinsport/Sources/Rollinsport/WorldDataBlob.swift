//
//  WorldDataBlob.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/11/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftGodot

struct WorldDataBlob: Codable {
    struct Position: Codable {
        var x: Float
        var y: Float
    }

    var playerPosition: Position
    var readScripts: [String]
}


extension Vector2 {
    init(codablePosition: WorldDataBlob.Position) {
        self.init(x: codablePosition.x, y: codablePosition.y)
    }
}

extension WorldDataBlob.Position {
    init(vector2: Vector2) {
        self.init(x: vector2.x, y: vector2.y)
    }
}
