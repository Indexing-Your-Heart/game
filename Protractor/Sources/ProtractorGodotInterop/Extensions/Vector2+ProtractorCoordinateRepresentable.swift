//
//  Vector2+ProtractorCoordinateRepresentable.swift
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

extension Vector2: ProtractorCoordinateRepresentable {
    public func translated(by point: Vector2) -> Vector2 {
        Vector2(x: x - point.x, y: y - point.y)
    }
}
