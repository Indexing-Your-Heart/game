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
// swiftlint:disable identifier_name
    func blended(withFraction: CGFloat, of color: SKColor) -> SKColor? {
        var (r1, g1, b1, a1)  = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2)  = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return .init(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: min(a1 + a2, 1))
    }
// swiftlint:enable identifier_name
#endif
}
