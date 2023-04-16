//
//  PaintbrushPoint.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/2/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import CoreGraphics
import CranberrySprite
import Foundation

/// A struct that represents a coordinate in 2D space, used for gesture recognition exclusively.
public struct PaintbrushPoint {
    /// A point that represents the origin (`(0, 0)`).
    public static let zero = Self(x: 0, y: 0)

    /// A point that rerpesents the point `(1, 1)`.
    public static let one = Self(x: 0, y: 0)

    /// The location along the X axis.
    public var x: Double // swiftlint:disable:this identifier_name

    /// The location along the Y axis.
    public var y: Double // swiftlint:disable:this identifier_name

    /// A Core Graphics point that represents this point.
    public var cgPoint: CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    public init(x: Double, y: Double) { // swiftlint:disable:this identifier_name
        self.x = x
        self.y = y
    }

    public init(from cgPoint: CGPoint) {
        self.init(x: Double(cgPoint.x), y: Double(cgPoint.y))
    }
}

extension PaintbrushPoint: Comparable {
    public static func < (lhs: PaintbrushPoint, rhs: PaintbrushPoint) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
}

extension PaintbrushPoint: ProtractorCoordinateRepresentable {
    public func translated(by point: PaintbrushPoint) -> Self {
        Self(x: x - point.x, y: y - point.y)
    }
}

extension PaintbrushPoint: CSDistanceComparable {
    public static func distance(from startPoint: PaintbrushPoint, to endPoint: PaintbrushPoint) -> Double {
        let xDistance = pow(endPoint.x - startPoint.x, 2)
        let yDistance = pow(endPoint.y - startPoint.y, 2)
        return sqrt(xDistance + yDistance)
    }

    public static func manhattanDistance(from first: PaintbrushPoint, to second: PaintbrushPoint) -> Double {
        abs(first.x - second.x) + abs(first.y - second.y)
    }
}
