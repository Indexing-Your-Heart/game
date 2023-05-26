//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/25/23.
//

import Foundation
import Protractor
import SwiftGodot

extension ProtractorPoint {
    /// A Vector2 that represents this point.
    public var vector: Vector2 {
        Vector2(x: Float(x), y: Float(y))
    }

    
    public init(from vector: Vector2) {
        self.init(x: Double(vector.x), y: Double(vector.y))
    }
}
