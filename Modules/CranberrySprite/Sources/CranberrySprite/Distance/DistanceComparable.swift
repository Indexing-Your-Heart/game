//
//  File.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

import Foundation
import CoreGraphics

/// A protocol that indicates an object can compare itself as distances.
public protocol CSDistanceComparable {
    /// A value that represents the distance between two points in a linear space.
    associatedtype Distance: Numeric

    /// Find the distance between two points.
    /// - Parameter startPoint: The starting point of the line to get the distance of.
    /// - Parameter endPoint: The ending point of the line to get the distance of.
    /// - Returns: The distance between the two points.
    static func distance(from startPoint: Self, to endPoint: Self) -> Distance

    /// Returns the Manhattan or city-block distance between two points.
    /// - Parameter first: The starting point of the line to get the distance of.
    /// - Parameter second: The destination point of the line to get the distance of.
    /// - Returns: A CGFloat rerpesenting the Manhattan distance between the two points.
    static func manhattanDistance(from first: Self, to second: Self) -> Distance
}

extension CGPoint: CSDistanceComparable {
    /// Find the distance between two points.
    /// - Parameter startPoint: The starting point of the line to get the distance of.
    /// - Parameter endPoint: The ending point of the line to get the distance of.
    /// - Returns: The distance between the two points.
    public static func distance(from startPoint: CGPoint, to endPoint: CGPoint) -> CGFloat {
        let xDistance = pow(endPoint.x - startPoint.x, 2)
        let yDistance = pow(endPoint.y - startPoint.y, 2)
        return sqrt(xDistance + yDistance)
    }

    /// Returns the Manhattan or city-block distance between two points.
    /// - Parameter first: The starting CGPoint
    /// - Parameter second: The destination CGPoint
    /// - Returns: A CGFloat rerpesenting the Manhattan distance between the two points.
    public static func manhattanDistance(from first: CGPoint, to second: CGPoint) -> CGFloat {
        abs(first.x - second.x) + abs(first.y - second.y)
    }
}
