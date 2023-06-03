//
//  ProtractorPoint+Vector2.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/25/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import Protractor
import SwiftGodot

public extension ProtractorPoint {
    /// A Vector2 that represents this point.
    var vector: Vector2 {
        Vector2(x: Float(x), y: Float(y))
    }

    init(from vector: Vector2) {
        self.init(x: Double(vector.x), y: Double(vector.y))
    }
}
