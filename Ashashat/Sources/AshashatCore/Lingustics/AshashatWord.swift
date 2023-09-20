//
//  AshashatWord.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/19/23.
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

/// A protocol that represents a word in [ʔaʃaʃat].
///
/// This protocol is used to construct words in the [ʔaʃaʃat] conlang with a syntax similar to SwiftUI.
public protocol AshashatWord {
    /// A type representing the underlying word as a linguistic representable.
    ///
    /// This type is used to define the associated linguistic content for use within areas that may require a string.
    associatedtype Word: LinguisticRepresentable

    /// The word this conforming type refers to.
    var word: Word { get }
}

/// A repair strategy specializing in phonotactic rules for [ʔaʃaʃat].
///
/// Typically, consonats cannot sit next to each other in the middle of a word. For example, `[i.ʔa.ʃa.ʃat.sa]` would
/// be an invalid combination because of the last two syllables.
///
/// The specification notes that, in these cases, the syllable should be broken up into two separate syllables. In most
/// cases, the `a` vowel is used:
///
/// ```
/// [i.ʔa.ʃa.ʃat.sa] -> [i.ʔa.ʃa.ʃa.ta.sa]
/// ```
public struct AshashatRepairStrategy: PhonotacticRepairStrategy {
    private static var remappings: [String: String] {
        [
            "l": "lu",
            "n": "na",
            "t": "ta",
            "ʃ": "ʃa"
        ]
    }

    private static func remap(_ syllable: Syllable) -> [Syllable] {
        for (suffix, replacement) in self.remappings {
            guard syllable.content.hasSuffix(suffix) else { continue }
            let initialSyllable = Syllable(content: String(syllable.content.dropLast()))
            let newSyllable = Syllable(content: replacement)
            return [initialSyllable, newSyllable]
        }
        return [syllable]
    }

    public func apply(_ first: Syllable, _ second: Syllable, endOfWord: Bool) -> [Syllable] {
        return Self.remap(first) + (endOfWord ? [second] : Self.remap(second))
    }
}

extension PhonotacticRepairStrategy where Self == AshashatRepairStrategy {
    /// The [ʔaʃaʃat] repair strategy.
    public static var ashashat: PhonotacticRepairStrategy { AshashatRepairStrategy() }
}

public extension String {
    /// Creates a string represented by an [ʔaʃaʃat] word.
    ///
    /// This initializer will create a string that displays the linguistic content of an [ʔaʃaʃat] word. For example,
    /// calling this with an ``AshashatPrimitive`` will generate a string showing the pronunciation of the word in the
    /// International Phonetic Alphabet (IPA):
    ///
    /// ```swift
    /// let userString = String(ashashatWord: AshashatPrimitive.thing)
    /// print("Thing is: \(userString)") // Thing is: [ʔaʃaʃat]
    /// ```
    init<T: AshashatWord>(ashashatWord word: T) {
        self = "[\(word.word)]"
    }
}

/// A representation of the [ʔaʃaʃat] primitive.
///
/// Besides the shapes defined in ``AshashatShape``, primitives are the only free morphemes in the conlang.
public enum AshashatPrimitive: AshashatWord {
    /// A living being that is considered to have human traits.
    ///
    /// The IPA pronunciation for this primitive is `[pu.baʃ]`.
    case person

    /// A living being that feeds on organic matter not representable by ``person``.
    ///
    /// The IPA pronunciation for this primitive is `[bu.peʃ]`.
    case animal

    /// An idea or abstract concept, such as emotions, words, and peace.
    ///
    /// The IPA pronunciation for this primitive is `[ʔaʃ]`.
    case idea

    /// A catch-all primitive representing things that cannot be described by its shape or living qualities.
    ///
    /// The IPA pronunciation for this is `[ʔa.ʃa.ʃat]`.
    case thing

    public var word: some LinguisticRepresentable {
        switch self {
        case .person:
            Morpheme(stringLiteral: "[pu.baʃ]")
        case .animal:
            Morpheme(stringLiteral: "[bu.peʃ]")
        case .idea:
            Morpheme(stringLiteral: "[ʔaʃ]")
        case .thing:
            Morpheme(stringLiteral: "[ʔa.ʃa.ʃat]")
        }
    }
}

/// A representation of the [ʔaʃaʃat] shape primitives.
///
/// Besides the general primitives in ``AshashatPrimitive``, shapes are the only free morphemes in the conlang.
public enum AshashatShape: AshashatWord {
    /// A circle, oval, or other ellipsoid in the second dimension.
    ///
    /// The IPA pronunciation for this is `[puk']`.
    ///
    /// - Note: To describe spheres or cylinders, use ``sphere`` or ``cylinder``, respectively.
    case ellipse

    /// A two-dimensional shape with two or more sides.
    ///
    /// The IPA pronunciation for this is `[ta.su.bi]`.
    case polygon

    /// A three-dimensional cylinder.
    ///
    /// The IPA pronunciation for this is `[ka.bu.tu.i]`.
    case cylinder

    /// A three-dimensional slab shape.
    ///
    /// The IPA pronunciation for this is `[si.ʃa]`.
    case slab

    /// A three-dimensional shape that is rectangular in nature but not as flat as a ``slab``.
    ///
    /// The IPA pronunciation for this is `[bi.ba]`.
    case box

    /// A three-dimensional shape with a square or rectangular base with sides meeting at the top.
    ///
    /// The IPA pronunciation for this is `[i.ku.tet]`.
    case pyramid

    /// A three-dimensional shape with an ellipse base, with sides meeting at the top.
    ///
    /// The IPA pronunciation for this is `[k'i:.a]`.
    case cone

    /// A three-dimensional rounded shape where all points are equidistant from each other.
    ///
    /// The IPA pronunciation for this is `[ʔi.lin]`.
    case sphere

    public var word: some LinguisticRepresentable {
        switch self {
        case .ellipse:
            Morpheme(stringLiteral: "[puk']")
        case .polygon:
            Morpheme(stringLiteral: "[ta.su.bi]")
        case .cylinder:
            Morpheme(stringLiteral: "[ka.bu.tu.i]")
        case .slab:
            Morpheme(stringLiteral: "[si.ʃa]")
        case .box:
            Morpheme(stringLiteral: "[bi.ba]")
        case .pyramid:
            Morpheme(stringLiteral: "[i.ku.tet]")
        case .cone:
            Morpheme(stringLiteral: "[k'i:.a]")
        case .sphere:
            Morpheme(stringLiteral: "[?i.lin]")
        }
    }
}
