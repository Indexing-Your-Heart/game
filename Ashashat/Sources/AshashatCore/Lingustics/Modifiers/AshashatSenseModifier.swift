//
//  AshashatSenseModifier.swift
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

public enum AshashatSenseModifier: AshashatModifier {
    case audio
    case visual
    case sniffable
    case tastable
    case tactile

    public var word: some LinguisticRepresentable {
        switch self {
        case .audio:
            Morpheme(stringLiteral: "[a.ʔa]")
        case .visual:
            Morpheme(stringLiteral: "[i.ʔi]")
        case .sniffable:
            Morpheme(stringLiteral: "[e.ʔe]")
        case .tastable:
            Morpheme(stringLiteral: "[u.ʔu]")
        case .tactile:
            Morpheme(stringLiteral: "[i.k'i]")
        }
    }
}

public struct SenseAshashatWord<Reference: AshashatWord>: AshashatWord {
    var sense: AshashatSenseModifier
    var reference: Reference

    internal init(sense: AshashatSenseModifier, reference: Reference) {
        self.sense = sense
        self.reference = reference
    }

    public var word: some LinguisticRepresentable {
        reference.word
            .prefixed(by: sense.word as! Reference.Word.BoundMorpheme,
                      repairingWith: .ashashat)
    }
}

extension SenseAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ SenseAshashatWord
        - Sense: \(sense)
        ▿ Reference: \(Reference.self)
          \(indented: reference)
       """
    }
}

public extension AshashatWord {
    func sense(_ sense: AshashatSenseModifier) -> some AshashatWord {
        SenseAshashatWord(sense: sense, reference: self)
    }
}
