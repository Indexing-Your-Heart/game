//
//  GenericWords.swift
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

struct PrefixedAshashatWord<Root: AshashatWord, Prefix: AshashatWord>: AshashatWord {
    var root: Root
    var prefix: Prefix

    var word: some LinguisticRepresentable {
        root.word.prefixed(by: prefix.word as! Root.Word.BoundMorpheme,
                           repairingWith: .ashashat)
    }
}

extension PrefixedAshashatWord: CustomStringConvertible {
    var description: String {
       """
       ▿ PrefixedAshashatWord
        ▿ Prefix: \(Prefix.self)
          \(indented: prefix)
        ▿ Root: \(Root.self)
          \(indented: root)
       """
    }
}

struct SuffixedAshashatWord<Root: AshashatWord, Suffix: AshashatWord>: AshashatWord {
    var root: Root
    var suffix: Suffix

    var word: some LinguisticRepresentable {
        root.word.suffixed(by: suffix.word as! Root.Word.BoundMorpheme,
                           repairingWith: .ashashat)
    }
}

extension SuffixedAshashatWord: CustomStringConvertible {
    var description: String {
       """
       ▿ SuffixedAshashatWord
        ▿ Suffix: \(Suffix.self)
          \(indented: suffix)
        ▿ Root: \(Root.self)
          \(indented: root)
       """
    }
}

struct InfixedAshashatWord<Root: AshashatWord, Infix: AshashatWord>: AshashatWord {
    var root: Root
    var infix: Infix

    var word: some LinguisticRepresentable {
        root.word.infixed(by: infix.word as! Root.Word.BoundMorpheme,
                          repairingWith: .ashashat)
    }
}

extension InfixedAshashatWord: CustomStringConvertible {
    var description: String {
       """
       ▿ InfixedAshashatWord
        ▿ Infix: \(Infix.self)
          \(indented: infix)
        ▿ Root: \(Root.self)
          \(indented: root)
       """
    }
}

struct CircumfixedAshashatWord<Root: AshashatWord, Circumfix: AshashatWord>: AshashatWord {
    var root: Root
    var circumfix: Circumfix

    var word: some LinguisticRepresentable {
        root.word.circumfixed(by: circumfix.word as! Root.Word.BoundMorpheme,
                              repairingWith: .ashashat)
    }
}

extension CircumfixedAshashatWord: CustomStringConvertible {
    var description: String {
       """
       ▿ CircumfixedAshashatWord
        ▿ Circumfix: \(Circumfix.self)
          \(indented: circumfix)
        ▿ Root: \(Root.self)
          \(indented: root)
       """
    }
}

// MARK: - AshashatWord Builder
extension AshashatWord {
    func prefix(_ prefixWord: some AshashatWord) -> some AshashatWord {
        PrefixedAshashatWord(root: self, prefix: prefixWord)
    }

    func suffix(_ suffixWord: some AshashatWord) -> some AshashatWord {
        SuffixedAshashatWord(root: self, suffix: suffixWord)
    }

    func infix(_ infixWord: some AshashatWord) -> some AshashatWord {
        InfixedAshashatWord(root: self, infix: infixWord)
    }

    func circumfix(_ circumfixWord: some AshashatWord) -> some AshashatWord {
        CircumfixedAshashatWord(root: self, circumfix: circumfixWord)
    }
}
