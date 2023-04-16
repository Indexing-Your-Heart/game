//
//  CGSizeExtension.swift
//
//
//  Created by Marquis Kurt on 8/4/22.
//

import Foundation
import CoreGraphics


public extension CGSize {
    /// Initialize a CGSize with an equal height and width.
    /// - Parameter square: The square's width/height.
    init(squareOf size: CGFloat) {
        self.init(width: size, height: size)
    }
}
