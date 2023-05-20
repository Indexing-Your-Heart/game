//
//  ProtractorCoordinateRepresentable.swift
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
import SwiftGodot
import Foundation

/// A protocol that indicates a point is able to be used for gesture recognition.
public protocol ProtractorCoordinateRepresentable {
    /// The component that the point uses to determine itself in a plane.
    associatedtype CoordinateComponent: BinaryFloatingPoint & Comparable

    /// The location along the X axis.
    var x: CoordinateComponent { get set } // swiftlint:disable:this identifier_name

    /// The location along the Y axis.
    var y: CoordinateComponent { get set } // swiftlint:disable:this identifier_name

    /// Translates the current point by offsetting it to another.
    /// - Parameter point: The point that the current point will be offset by.
    /// - Returns: A new point with the translation applied.
    func translated(by point: Self) -> Self
}

extension CGPoint: ProtractorCoordinateRepresentable {
    public func translated(by point: CGPoint) -> CGPoint {
        CGPoint(x: x - point.x, y: y - point.y)
    }
}

extension Vector2: ProtractorCoordinateRepresentable {
    public func translated(by point: Vector2) -> Vector2 {
        Vector2(x: x - point.x, y: y - point.y)
    }
}
