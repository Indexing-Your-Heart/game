//
//  AshashatPossessionModifier.swift
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

import ConlangKit
import Foundation

/// An [ʔaʃaʃat] word that is in its possesive form.
///
/// This can only be constructed using the ``AshashatWord/owning()`` method.
public struct PossessedAshashatWord<Owned: AshashatWord>: AshashatWord {
    /// The word in its non-possessive form.
    var owningItem: Owned

    internal init(owningItem: Owned) {
        self.owningItem = owningItem
    }

    public var word: some LinguisticRepresentable {
        owningItem.word
            .circumfixed(by: PossessionAshashatWord().word as! Owned.Word.BoundMorpheme, repairingWith: .ashashat)
    }
}

/// A struct containing the [ʔaʃaʃat] prefix of the possessive modifier.
public struct PossessionAshashatWord: AshashatModifier {
    public var word: some LinguisticRepresentable {
        Morpheme(stringLiteral: "[k'a.su:p]")
    }

    internal init() {}
}

extension PossessedAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ PossessedAshashatWord
        ▿ Owned: \(Owned.self)
          \(indented: owningItem)
       """
    }
}

public extension AshashatWord {
    /// Marks the word as a possessive.
    ///
    /// This is applied as a circumfix to an existing primitive or modifier.
    func owning() -> some AshashatWord {
        PossessedAshashatWord(owningItem: self)
    }

    /// Marks the word as a possessive.
    ///
    /// This is applied as a circumfix to an existing primitive or modifier.
    /// - Parameter builder: A closure used to attach any modifier-only properties.
    func owning(properties builder: (PossessionAshashatWord) -> some AshashatWord) -> some AshashatWord {
        self.circumfix(builder(.init()))
    }
}
