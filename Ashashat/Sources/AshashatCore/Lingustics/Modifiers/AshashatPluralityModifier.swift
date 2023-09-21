//
//  AshashatPluralityModifier.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/17/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import ConlangKit
import Foundation

/// A modifier describing the different pluralities a word can take.
public enum AshashatPluralityModifier: AshashatWord {
    /// The amount is zero or non-existent.
    case none

    /// The amount describes a countable item, typically a small amount.
    ///
    /// ### Opaque Plurality
    /// This modifier can also represent _opaque plurality_, where the exact amount is unknown or is not explcitly
    /// relevant to the word itself. For example, "a pile of gravel" would take this modifier with an opaque plural
    /// because the exact amount of grains in the pile are either unknown or not relevant.
    ///
    /// - Tip: Opaque plurality works very similarly to opaque types in the Swift language.
    case some

    /// The amount describes a mass or a big amount of a countable item.
    case many

    public var word: some LinguisticRepresentable {
        switch self {
        case .none:
            Morpheme(stringLiteral: "[i:]")
        case .some:
            Morpheme(stringLiteral: "[i.sa]")
        case .many:
            Morpheme(stringLiteral: "[i.sa.te]")
        }
    }
}

/// An [ʔaʃaʃat] word that has been pluralized.
///
/// This can only be constructed using the ``AshashatWord/pluralized(_:)`` modifier.
struct PluralizedAshashatWord<SingularForm: AshashatWord>: AshashatWord {
    /// The plural modifier that applies to this word.
    var plural: AshashatPluralityModifier

    /// The singular form of the word being pluralized.
    var singularForm: SingularForm

    var word: some LinguisticRepresentable {
        // NOTE: The force case here must be applied to coerce the plural modifier's word to be treated as a bound
        // morpheme. This looks like some freaky type gymnastics, but it is technically true that plurals are bound
        // morphemes.
        //
        // Obel help us if we end up changing the underlying type of the plural modifier...
        singularForm.word
            .circumfixed(by: plural.word as! SingularForm.Word.BoundMorpheme, // swiftlint:disable:this force_cast
                         repairingWith: .ashashat)
    }
}

public extension AshashatWord {
    /// Marks the current word as a plural.
    ///
    /// Plural modifiers are applied as a circumfix to an existing primitive or modifier. For example, the following
    /// word will produce "some things" (`[iʔaʃaʃatasa]`):
    ///
    /// ```swift
    /// var word: some AshashatWord {
    ///     AshashatPrimitive.thing
    ///         .pluralized(.some) // produces '[iʔaʃaʃatasa]'
    /// }
    /// ```
    ///
    /// > The absence of an item is considered a plural modifier and used ``AshashatPluralityModifier/none``:
    /// > ```swift
    /// > var nothing: some AshashatWord {
    /// >   AshashatPrimitive.thing
    /// >       .pluralized(.none) // produces '[iʔaʃaʃat]'
    /// > ```
    ///
    /// - Parameter pluralType: The plural amount being applied to the word.
    func pluralized(_ pluralType: AshashatPluralityModifier) -> some AshashatWord {
        PluralizedAshashatWord(plural: pluralType, singularForm: self)
    }
}
