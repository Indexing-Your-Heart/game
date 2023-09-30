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

/// A modifier that represents colors in [ʔaʃaʃat].
public enum AshashatColorModifier: AshashatModifier {
    /// A red color.
    case red

    /// An orange color.
    case orange

    /// A yellow color.
    case yellow

    /// A green color.
    case green

    /// A blue color.
    case blue

    /// An indigo color.
    case indigo

    /// A purple color.
    case pruple

    /// A black color.
    case black

    /// A white color.
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

/// A word with an associated color.
///
/// This can only be constructed with the ``AshashatWord/color(_:)`` or ``AshashatWord/color(_:propertiesBuilder:)``
/// modifiers.
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
    /// Associates the word with a specified color.
    ///
    /// Colors are applied as prefixes to a word. For example, the following produces "apple":
    ///
    /// ```swift
    /// let apple: some AshashatWord = {
    ///     AshashatShape.sphere
    ///         .sense(.tastable)
    ///         .color(.red)
    /// }()
    /// ```
    ///
    /// - Parameter color: The color to associated with the word.
    func color(_ color: AshashatColorModifier) -> some AshashatWord {
        ColorizedAshashatWord(color: color, uncoloredItem: self)
    }

    /// Associates the word with a specified color.
    ///
    /// Colors are applied as prefixes to a word. For example, the following produces "apple":
    ///
    /// ```swift
    /// let apple: some AshashatWord = {
    ///     AshashatShape.sphere
    ///         .sense(.tastable)
    ///         .color(.red)
    /// }()
    /// ```
    ///
    /// - Parameter color: The color to associated with the word.
    /// - Parameter propertiesBuilder: A closure that transforms the color. Use this for modifiers that require
    ///   modifying an existing modifier.
    func color(
        _ color: AshashatColorModifier,
        propertiesBuilder: @escaping (AshashatColorModifier) -> some AshashatWord
    ) -> some AshashatWord {
        PrefixedAshashatWord(root: self, prefix: propertiesBuilder(color))
    }
}
