//
//  AshashatKeboardKey.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/21/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftGodot

/// An enumeration that represents a key on the [ʔaʃaʃat] keyboard.
public enum AshashatKeyboardKey: String, CaseIterable {
    case a, i, e, u
    case p, b, t, k, n, s, l
    case ejectiveK = "ejective_k"
    case sh, glottal
    case repeater, duplicant
    case `return`, delete

    /// The key's value.
    ///
    /// When appending to a text field, this value should be used.
    public var keyValue: String {
        switch self {
        case .repeater: ":"
        case .duplicant: "!"
        case .ejectiveK: "k'"
        case .sh: "ʃ"
        case .glottal: "ʔ"
        case .delete, .return: ""
        default: self.rawValue
        }
    }

    /// The key's value as rendered using the [ʔaʃaʃat] fonts.
    ///
    /// [iʔaʃakasubapenasate] renders characters using font ligatures. As such, typically, some key combinations don't
    /// necessarily match ``keyValue``.
    ///
    /// This should be used for labels that set their font to be a variant of the [iʔaʃakasubapenasate] family.
    public var fontRenderedValue: String {
        switch self {
        case .repeater:
            return "*"
        case .ejectiveK:
            return "K"
        case .sh:
            return "sh"
        default:
            return self.keyValue
        }
    }

    /// The key's registered key code.
    ///
    /// When ``AshashatKeyboardInterpreter/keyPressedSignalName`` emits, this value will be provided as an argument.
    public var keyCode: String {
        "ashashat_key_\(self.rawValue)"
    }

    /// Initializes a key, deriving from its key code.
    /// - Parameter keyCode: The key code the key should decode from.
    public init?(keyCode: String) {
        self.init(rawValue: keyCode.replacingOccurrences(of: "ashashat_key_", with: ""))
    }
}

public extension AshashatKeyboardKey {
    static var vowels: [AshashatKeyboardKey] {
        [.a, .e, .i, .u]
    }

    static var consonants: [AshashatKeyboardKey] {
        [.p, .b, .t, .k, .n, .s, .l, .glottal, .sh, .ejectiveK]
    }

    static var symbols: [AshashatKeyboardKey] {
        [.repeater, .duplicant]
    }
}
