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

/// A modifier containing [ʔaʃaʃat] speeds.
public enum AshashatSpeedModifier: AshashatModifier {
    /// A slow speed.
    case slow

    /// A fast speed.
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

/// An [ʔaʃaʃat] word with an associated speed.
///
/// This can only be constructed using the ``AshashatWord/speed(_:)`` modifier.
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
    /// Applies a speed modifier to the word.
    ///
    /// Speed modifiers are applied as prefixes to a given word. For example, the following will produce "fast ball":
    ///
    /// ```swift
    /// let fastBall: some AshashatWord = {
    ///     AshashatShape.sphere
    ///         .speed(.fast)
    /// }()
    /// ```
    ///
    /// - Parameter speed: The speed at which the item moves.
    func speed(_ speed: AshashatSpeedModifier) -> some AshashatWord {
        MovingAshashatWord(speed: speed, mass: self)
    }
}
