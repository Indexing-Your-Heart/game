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

import Foundation
import CoreGraphics
import CranberrySprite

public struct PaintbrushPoint {
    public static let zero = Self(x: 0, y: 0)
    public static let one = Self(x: 0, y: 0)

    public var x: Double // swiftlint:disable:this identifier_name
    public var y: Double // swiftlint:disable:this identifier_name

    public var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    public init(x: Double, y: Double) { // swiftlint:disable:this identifier_name
        self.x = x
        self.y = y
    }

    public init(from cgPoint: CGPoint) {
        self.init(x: Double(cgPoint.x), y: Double(cgPoint.y))
    }
}

extension PaintbrushPoint: ProtractorCoordinateRepresentable {
    public func translated(by point: PaintbrushPoint) -> Self {
        Self(x: self.x - point.x, y: self.y - point.y)
    }
}

extension PaintbrushPoint: CSDistanceComparable {
    public static func distance(from startPoint: PaintbrushPoint, to endPoint: PaintbrushPoint) -> Double {
        let xDistance = pow(endPoint.x - startPoint.x, 2)
        let yDistance = pow(endPoint.y - startPoint.y, 2)
        return sqrt(xDistance + yDistance)
    }

    public static func manhattanDistance(from first: PaintbrushPoint, to second: PaintbrushPoint) -> Double {
        return abs(first.x - second.x) + abs(first.y - second.y)
    }
}
