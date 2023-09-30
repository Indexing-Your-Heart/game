//
//  AshashatScientificModifier.swift
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

public enum AshashatScientificModifier: AshashatModifier {
    case natural
    case physical
    case chemical
    case electrical

    public var word: some LinguisticRepresentable {
        switch self {
        case .natural:
            Morpheme(stringLiteral: "[i.sa.lu]")
        case .physical:
            Morpheme(stringLiteral: "[i.ʃa.lu]")
        case .chemical:
            Morpheme(stringLiteral: "[i.ka.lu]")
        case .electrical:
            Morpheme(stringLiteral: "[e.ʃa.ku]")
        }
    }
}

public struct ScientificDomainAshashatWord<Object: AshashatWord>: AshashatWord {
    var domain: AshashatScientificModifier
    var reference: Object

    internal init(domain: AshashatScientificModifier, reference: Object) {
        self.domain = domain
        self.reference = reference
    }

    public var word: some LinguisticRepresentable {
        reference.word.circumfixed(by: domain.word as! Object.Word.BoundMorpheme,
                                   repairingWith: .ashashat)
    }
}

extension ScientificDomainAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ ScientificDomainAshashatWord
        - Domain: \(domain)
        ▿ Reference: \(Object.self)
          \(indented: reference)
       """
    }
}

public extension AshashatWord {
    func scientificDomain(_ domain: AshashatScientificModifier) -> some AshashatWord {
        ScientificDomainAshashatWord(domain: domain, reference: self)
    }
}
