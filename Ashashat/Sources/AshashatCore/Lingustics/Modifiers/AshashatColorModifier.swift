//
//  AshashatColorModifier.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/23.
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
import ConlangKit

public enum AshashatColorModifier: AshashatModifier {
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case pruple
    case black
    case white

    public var word: some LinguisticRepresentable {
        switch self {
        case .red:
            Morpheme(stringLiteral: "[ta.ta]")
        case .orange:
            Morpheme(stringLiteral: "[ti.ti]")
        case .yellow:
            Morpheme(stringLiteral: "[tu.tu]")
        case .green:
            Morpheme(stringLiteral: "[na.na]")
        case .blue:
            Morpheme(stringLiteral: "[ni.ni]")
        case .indigo:
            Morpheme(stringLiteral: "[ne.ne]")
        case .pruple:
            Morpheme(stringLiteral: "[nu.nu]")
        case .black:
            Morpheme(stringLiteral: "[a.k'a]")
        case .white:
            Morpheme(stringLiteral: "[a.ʃa]")
        }
    }
}

public struct ColorizedAshashatWord<UncoloredItem: AshashatWord>: AshashatWord {
    var color: AshashatColorModifier
    var uncoloredItem: UncoloredItem

    internal init(color: AshashatColorModifier, uncoloredItem: UncoloredItem) {
        self.color = color
        self.uncoloredItem = uncoloredItem
    }

    public var word: some LinguisticRepresentable {
        uncoloredItem.word
            .prefixed(by: color.word as! UncoloredItem.Word.BoundMorpheme,
                      repairingWith: .ashashat)
    }
}

extension ColorizedAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ ColorizedAshashatWord
        - Color: \(color)
        ▿ UncoloredItem: \(UncoloredItem.self)
          \(indented: uncoloredItem)
       """
    }
}

public extension AshashatWord {
    func color(_ color: AshashatColorModifier) -> some AshashatWord {
        ColorizedAshashatWord(color: color, uncoloredItem: self)
    }

    func color(
        _ color: AshashatColorModifier,
        propertiesBuilder: @escaping (AshashatColorModifier) -> some AshashatWord
    ) -> some AshashatWord {
        PrefixedAshashatWord(root: self, prefix: propertiesBuilder(color))
    }
}
