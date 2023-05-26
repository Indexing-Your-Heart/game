//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/25/23.
//

import Foundation
import Protractor
import SwiftGodot

extension Vector2: ProtractorCoordinateRepresentable {
    public func translated(by point: Vector2) -> Vector2 {
        Vector2(x: x - point.x, y: y - point.y)
    }
}
