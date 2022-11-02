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

import Foundation
import CoreGraphics

public protocol ProtractorPathConvertible {
    associatedtype Point: ProtractorCoordinateRepresentable
    var points: [Point] { get set }
    var centroid: Point { get }
    var count: Point.CoordinateComponent { get }
    var indicativeAngle: Point.CoordinateComponent { get }
    var length: Point.CoordinateComponent { get }
    func resampled(count: Int) -> Self
    func vectorized(accountsForOrientation orientationSensitive: Bool) -> [Point.CoordinateComponent]
}
