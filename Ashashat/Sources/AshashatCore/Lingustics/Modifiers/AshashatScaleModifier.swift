//
//  AshashatScaleModifier.swift
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

import ConlangKit
import Foundation

/// A modifier that contains scaleable sizes in [ʔaʃaʃat].
public enum AshashatScaleModifier: AshashatModifier {
    /// A small scale or size.
    case small

    /// A medium scale or size.
    case medium

    /// A large scale or size.
    case large

    public var word: some LinguisticRepresentable {
        switch self {
        case .small:
            Morpheme(stringLiteral: "[ʃa]")
        case .medium:
            Morpheme(stringLiteral: "[ʃe]")
        case .large:
            Morpheme(stringLiteral: "[ʃi]")
        }
    }
}

/// A modifer that specifies an axis for a scale or size in [ʔaʃaʃat].
public enum AshashatScaleAxisModifier: AshashatModifier {
    /// Applies along a word's length.
    case length

    /// Applies along a word's width.
    case width

    public var word: some LinguisticRepresentable {
        switch self {
        case .length:
            Morpheme(stringLiteral: "[k'a.ʃa]")
        case .width:
            Morpheme(stringLiteral: "[k'i.ʃi]")
        }
    }
}

/// An [ʔaʃaʃat] word with an associated scale, with an optional axis.
///
/// This can only be constructed with the ``scaled(to:axis:)`` modifier.
public struct ScaledAshashatWord<Reference: AshashatWord>: AshashatWord {
    var scale: AshashatScaleModifier
    var axis: AshashatScaleAxisModifier?
    var reference: Reference

    internal init(scale: AshashatScaleModifier,
                  axis: AshashatScaleAxisModifier? = nil,
                  reference: Reference) {
        self.scale = scale
        self.axis = axis
        self.reference = reference
    }

    public var word: some LinguisticRepresentable {
        if let axis {
            return reference.word
                .suffixed(by: scale.word as! Reference.Word.BoundMorpheme,
                          repairingWith: .ashashat)
                .suffixed(by: axis.word as! Reference.Word.Compound.BoundMorpheme,
                          repairingWith: .ashashat) as! Reference.Word.Compound
        } else {
            return reference.word
                .suffixed(by: scale.word as! Reference.Word.BoundMorpheme,
                          repairingWith: .ashashat)
        }
    }
}

extension ScaledAshashatWord: CustomStringConvertible {
    public var description: String {
       """
       ▿ ScaledAshashatWord
        - Scale: \(scale)
        - Axis: \(String(describing: axis))
        ▿ Reference: \(Reference.self)
          \(indented: reference)
       """
    }
}

public extension AshashatWord {
    /// Applies a scale to a specified word.
    ///
    /// Scales/sizes are applied as suffixes to a word, along with an axis if specified. For example, the following
    /// produces "big ball":
    ///
    /// ```swift
    /// let bigBall: some AshashatWord = {
    ///     AshashatShape.sphere
    ///         .scaled(to: .large)
    /// }()
    /// ```
    ///
    /// - Parameter scale: The scale or size of the word.
    /// - Parameter axis: The axis of which the scale applies, if applicable.
    func scaled(to scale: AshashatScaleModifier, axis: AshashatScaleAxisModifier? = nil) -> some AshashatWord {
        ScaledAshashatWord(scale: scale, axis: axis, reference: self)
    }
}
