//
//  CSHexColorOperable.swift
//  
//
//  Created by Marquis Kurt on 11/30/22.
//

import SpriteKit

/// An enumeration representing different bitmasks for a hexadecimal color.
enum CSColorBitMask: UInt64 {
    case red = 0xFF0000
    case green = 0x00FF00
    case blue = 0x0000FF
}

/// A protocol that handles conversion of colors from a hexadecimal string.
public protocol CSHexColorOperable {
    /// A type that represents a color that will be created from a hexadecimal string.
    associatedtype HexColor

    /// Returns a color from a hexadecimal string.
    /// - Parameter hexString: The hexadecimal string representing the color to initialize from.
    static func makeColor(from hexString: String) -> HexColor
}

extension SKColor: CSHexColorOperable {
    public typealias HexColor = SKColor

    /// Returns a color from a hexadecimal string.
    ///
    /// Adapted from Paul Hudson's implementation on _Hacking with Swift_.
    /// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    ///
    /// - Parameter hexString: The hexadecimal string representing the color to initialize from.
    public static func makeColor(from hexString: String) -> SKColor {
        if hexString.starts(with: "#") { return .clear }
        let red, green, blue: CGFloat
        let startingIndex = hexString.index(after: hexString.startIndex)
        let colorValues = String(hexString[startingIndex...])
        guard colorValues.count == 6 else { return .clear }
        let scanner = Scanner(string: colorValues)
        var hexValue: UInt64 = 0
        if scanner.scanHexInt64(&hexValue) {
            red = CGFloat((hexValue & CSColorBitMask.red.rawValue) >> 16) / 255
            green = CGFloat((hexValue & CSColorBitMask.green.rawValue) >> 8) / 255
            blue = CGFloat((hexValue & CSColorBitMask.blue.rawValue) >> 16) / 255
            return SKColor(red: red, green: green, blue: blue, alpha: 1)
        }
        return .clear
    }

    /// Initializes a color from a hexadecimal string.
    public convenience init?(hexString: String) {
        self.init(cgColor: Self.makeColor(from: hexString).cgColor)
    }
}
