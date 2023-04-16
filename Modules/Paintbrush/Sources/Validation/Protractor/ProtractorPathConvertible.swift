//
//  ProtractorPathConvertible.swift
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
import Foundation

/// A protocol that indicates an object can store a series of points used for gesture recognition.
public protocol ProtractorPathConvertible {
    /// The representation of a point in a path.
    associatedtype Point: ProtractorCoordinateRepresentable

    /// An array of points that make up the path.
    var points: [Point] { get set }

    /// The point that represents the average of all points in the path.
    var centroid: Point { get }

    /// The number of points in the path.
    var count: Point.CoordinateComponent { get }

    /// The angle between the centroid and the first point in the path.
    var indicativeAngle: Point.CoordinateComponent { get }

    /// The path's length; i.e, the distance between all points in the path.
    var length: Point.CoordinateComponent { get }

    /// Resamples a path to a certain number of equidistant points.
    /// - Parameter count: The number of points that will be included in the resampled path. It is recommended to use
    /// at least 16 points when implementing with the Protractor algorithm.
    func resampled(count: Int) -> Self

    /// Creates a vector array representation of the path.
    /// - Parameter orientationSensitive: Whether to account for the path's orientation.
    func vectorized(accountsForOrientation orientationSensitive: Bool) -> [Point.CoordinateComponent]
}
