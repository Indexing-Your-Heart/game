//
//  AshashatSpeedModifier.swift
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

public enum AshashatSpeedModifier: AshashatModifier {
    case slow
    case fast

    public var word: some LinguisticRepresentable {
        switch self {
        case .slow:
            Morpheme(stringLiteral: "[a.ke]")
        case .fast:
            Morpheme(stringLiteral: "[a.k'i]")
        }
    }
}

public struct MovingAshashatWord<Mass: AshashatWord>: AshashatWord {
    var speed: AshashatSpeedModifier
    var mass: Mass

    internal init(speed: AshashatSpeedModifier, mass: Mass) {
        self.speed = speed
        self.mass = mass
    }

    public var word: some LinguisticRepresentable {
        mass.word
            .prefixed(by: speed.word as! Mass.Word.BoundMorpheme,
                      repairingWith: .ashashat)
    }
}

extension MovingAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ MovingAshashatWord
        - Speed: \(speed)
        ▿ Mass: \(Mass.self)
          \(indented: mass)
       """
    }
}

public extension AshashatWord {
    func speed(_ speed: AshashatSpeedModifier) -> some AshashatWord {
        MovingAshashatWord(speed: speed, mass: self)
    }
}
