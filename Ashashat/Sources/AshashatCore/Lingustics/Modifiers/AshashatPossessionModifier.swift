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

import Foundation

/// An [ʔaʃaʃat] word that is in its possesive form.
///
/// This can only be constructed using the ``AshashatWord/owning()`` method.
struct PossessedAshashatWord<Owned: AshashatWord>: AshashatWord {
    /// The word in its non-possessive form.
    var owningItem: Owned

    private var owningPrefix: some LinguisticRepresentable {
        Morpheme(stringLiteral: "[k'a.su:p]")
    }

    var word: some LinguisticRepresentable {
        owningItem.word
            .circumfixed(by: owningPrefix as! Owned.Word.BoundMorpheme,
                         repairingWith: LinguisticRepairStrategy.ashashat)
    }
}

public extension AshashatWord {
    /// Marks the word as a possessive.
    ///
    /// This is applied as a circumfix to an existing primitive or modifier.
    func owning() -> some AshashatWord {
        PossessedAshashatWord(owningItem: self)
    }
}
