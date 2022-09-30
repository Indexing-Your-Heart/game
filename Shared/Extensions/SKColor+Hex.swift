//
//  SKColor+Hex.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SpriteKit
import SwiftUI

public extension SKColor {
    /// Initializes a SpriteColor from a hexadecimal string, or clear if the conversion fails.
    ///
    /// Adapted from Paul Hudson's implementation on _Hacking with Swift_.
    /// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    ///
    /// - Parameter hexString: The hexadecimal string representing the color to initialize from.
    convenience init(hexString: String) {
        guard hexString.starts(with: "#") else {
            self.init(.clear)
            return
        }
        let r, g, b: CGFloat // swiftlint:disable:this identifier_name
        let startingIdx = hexString.index(hexString.startIndex, offsetBy: 1)
        let colorContents = String(hexString[startingIdx...])
        guard colorContents.count == 6 else {
            self.init(.clear)
            return
        }
        let scanner = Scanner(string: colorContents)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000FF) / 255
            self.init(Color(cgColor: .init(red: r, green: g, blue: b, alpha: 1)))
            return
        }
        self.init(.clear)
    }

#if os(iOS)
    /// Creates a new color object whose component values are a weighted sum of the current color object and the
    /// specified color object's.
    ///
    /// This implementation tries to mimic the same behavior present in `NSColor.blended` for consistency across
    /// platforms.
    ///
    /// - Parameter frac: The amount of the color to blend with the receiver's color. The method converts `color` and a
    /// copy of the receiver to RGB, and then sets each component of the returned color to `fraction` of `color`’s value
    /// plus `1 – fraction` of the receiver’s.
    /// - Parameter color: The color to blend with the receiver's color.
    /// - Returns: The resulting color object or `nil` if the colors can’t be converted.
    func blended(withFraction frac: CGFloat, of color: SKColor) -> SKColor? {
        var (recRed, recGreen, recBlue, recAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (colRed, colGreen, colBlue, colAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        getRed(&recRed, green: &recGreen, blue: &recBlue, alpha: &recAlpha)
        color.getRed(&colRed, green: &colGreen, blue: &colBlue, alpha: &colAlpha)

        var (newRed, newBlue, newGreen, newAlpha) = (colRed * frac, colBlue * frac, colGreen * frac, colAlpha * frac)
        newRed += (1 - frac) * recRed
        newBlue += (1 - frac) * recBlue
        newGreen += (1 - frac) * recGreen
        newAlpha += (1 - frac) * recAlpha

        return .init(
            red: min(newRed, 1),
            green: min(newBlue, 1),
            blue: min(newGreen, 1),
            alpha: min(newAlpha, 1)
        )
    }
#endif
}
