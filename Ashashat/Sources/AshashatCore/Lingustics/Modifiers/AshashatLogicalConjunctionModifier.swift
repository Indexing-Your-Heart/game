//
//  AshashatLogicalConjunctionModifier.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/24/23.
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

/// A modifier containing [ʔaʃaʃat] logical conjunctions.
public enum AshashatLogicalConjunctionModifier: AshashatModifier {
    /// The NOT operator, indicating the opposite or inverse of the word.
    ///
    /// For example, `[ʔa | sukaʔa | ʃababin]` translates to "unmarkable idea".
    case not

    /// An extension of the NOT operator that is permanent.
    case never

    /// The AND operator, which is used to conjoin two morphemes together.
    case and

    /// The OR operator, indicating a choice or a set of options.
    case or

    /// The XOR operator, indicating a singular choice in a set of options.
    ///
    /// - Note: This is mostly a shorthand operator instead of combining multiple AND, OR, and NOT operators.
    case xor

    public var word: some LinguisticRepresentable {
        switch self {
        case .not:
            return Morpheme(stringLiteral: "[su.kaʔ]")
        case .never:
            return Morpheme(stringLiteral: "[su.ka.k'aʔ]")
        case .and:
            return Morpheme(stringLiteral: "[su.ki]")
        case .or:
            return Morpheme(stringLiteral: "[su.ke]")
        case .xor:
            return Morpheme(stringLiteral: "[ʃu.ke.k'e]")
        }
    }
}

/// An [ʔaʃaʃat] word with an attached logical conjunction.
///
/// This can only be constructed using the ``AshashatWord/logicalConjunction(using:)`` modifier.
public struct LogicalAshashatWord<Object: AshashatWord>: AshashatWord {
    var `operator`: AshashatLogicalConjunctionModifier
    var object: Object

    internal init(operator: AshashatLogicalConjunctionModifier, object: Object) {
        self.operator = `operator`
        self.object = object
    }

    public var word: some LinguisticRepresentable {
        object.word
            .infixed(by: `operator`.word as! Object.Word.BoundMorpheme,
                     repairingWith: .ashashat)
    }
}

extension LogicalAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ LogicalAshashatWord
        - Conjunction: \(`operator`)
        ▿ Object: \(Object.self)
          \(indented: object)
       """
    }
}

public extension AshashatWord {
    /// Applies a logical conjunction to the word.
    ///
    /// Logical conjunctions are applied as infixes to a given word. For example, the following will produce
    /// "unmarkable idea" (`[ʔasukaʔaʃababin]`):
    ///
    /// ```swift
    /// let unmarkableIdea: some AshashatWord = {
    ///     AshashatPrimitive.idea
    ///         .action(.markable)
    ///         .logicalConjunction(using: .not)
    /// }()
    /// ```
    ///
    /// - Parameter operator: The conjunction to apply.
    func logicalConjunction(using operator: AshashatLogicalConjunctionModifier) -> some AshashatWord {
        LogicalAshashatWord(operator: `operator`, object: self)
    }
}
