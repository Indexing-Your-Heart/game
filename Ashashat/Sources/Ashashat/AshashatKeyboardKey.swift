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

enum AshashatKeyboardKey: String, CaseIterable {
    case a, i, e, u
    case p, b, t, k, n, s, l
    case ejectiveK = "ejective_k"
    case sh, glottal
    case repeater, duplicant
    case `return`, delete

    var keyValue: String {
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

    var keyCode: String {
        "ashashat_key_\(self.rawValue)"
    }
}

extension AshashatKeyboardKey {
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
