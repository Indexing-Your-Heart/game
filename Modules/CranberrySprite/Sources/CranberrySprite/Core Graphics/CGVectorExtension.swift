//
//  CGVectorExtension.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import Foundation
import CoreGraphics

public extension CGVector {
    /// Returns the magnituide of the vector.
    /// - Returns: The magnituide of the vector.
    func magnitude() -> CGFloat {
        sqrt(pow(dx, 2) + pow(dy, 2))
    }
}

extension CGVector: Comparable {
    /// Determine if a vector is less than another.
    public static func < (left: CGVector, right: CGVector) -> Bool {
        left.magnitude() < right.magnitude()
    }
}
