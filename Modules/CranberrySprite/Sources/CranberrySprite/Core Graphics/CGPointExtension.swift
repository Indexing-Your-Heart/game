//
//  CGPointExtension.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import Foundation
import CoreGraphics

public extension CGPoint {
    /// Find the distance between this point and another point.
    /// - Parameter point: The point to compare the distance of.
    /// - Returns: The distance between this point and the specified point.
    func distance(between point: CGPoint) -> CGFloat {
        CGPoint.distance(from: point, to: self)
    }

    /// Returns the Manhattan or city-block distance between two points.
    /// - Parameter point: The destination CGPoint from itself.
    /// - Returns: A CGFloat rerpesenting the Manhattan distance between the two points.
    func manhattanDistance(to point: CGPoint) -> CGFloat {
        CGPoint.manhattanDistance(from: self, to: point)
    }
}
