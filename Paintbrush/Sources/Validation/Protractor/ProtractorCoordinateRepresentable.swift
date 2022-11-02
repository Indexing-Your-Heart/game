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

import Foundation
import CoreGraphics

public protocol ProtractorCoordinateRepresentable {
    associatedtype CoordinateComponent: BinaryFloatingPoint & Comparable
    var x: CoordinateComponent { get set } // swiftlint:disable:this identifier_name
    var y: CoordinateComponent { get set } // swiftlint:disable:this identifier_name
    func translated(by point: Self) -> Self
}

extension CGPoint: ProtractorCoordinateRepresentable {
    public func translated(by point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
}
