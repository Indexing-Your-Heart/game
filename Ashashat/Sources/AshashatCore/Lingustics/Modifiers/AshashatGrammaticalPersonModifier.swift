//
//  AshashatGrammaticalPersonModifier.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/20/23.
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

/// A modifier describing the grammatical person associated with the word.
public enum AshashatGrammaticalPersonModifier: AshashatWord {
    /// The first person (i.e., the speaker).
    case first

    /// The second person (i.e., the recipient or other speaker).
    case second

    /// The third person.
    case third

    public var word: some LinguisticRepresentable {
        switch self {
        case .first:
            Morpheme(stringLiteral: "[ba]")
        case .second:
            Morpheme(stringLiteral: "[bi]")
        case .third:
            Morpheme(stringLiteral: "[bu]")
        }
    }
}

/// An [ʔaʃaʃat] word with an attached grammatical person.
///
/// This can only be constructed using the ``AshashatWord/grammaticalPerson(_:)`` modifier.
struct GrammaticalPersonAshashatWord<Reference: AshashatWord>: AshashatWord {
    /// The grammatical person associated with this word.
    var person: AshashatGrammaticalPersonModifier

    /// The reference word for which the grammatical person is assigned to.
    var reference: Reference

    var word: some LinguisticRepresentable {
        reference.word
            .prefixed(by: person.word as! Reference.Word.BoundMorpheme, // swiftlint:disable:this force_cast
                      repairingWith: .ashashat)
    }
}

public extension AshashatWord {
    /// Specifies an associated grammatical person.
    ///
    /// Grammtical person modifiers are applied as prefixes, typically for modifiers. For example, the following
    /// produces "your idea":
    ///
    /// ```swift
    /// var word: some AshashatWord {
    ///     AshashatPrimitive.idea
    ///         .owning()
    ///         .grammaticalPerson(.first) // produces [bik'aʔaʃasu:p]
    /// }
    /// ```
    ///
    /// - Parameter person: The grammatical person to associate with the word.
    func grammaticalPerson(_ person: AshashatGrammaticalPersonModifier) -> some AshashatWord {
        GrammaticalPersonAshashatWord(person: person, reference: self)
    }
}
