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

public enum AshashatScaleModifier: AshashatModifier {
    case small
    case medium
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

public enum AshashatScaleAxisModifier: AshashatModifier {
    case length
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
    func scaled(to scale: AshashatScaleModifier, axis: AshashatScaleAxisModifier? = nil) -> some AshashatWord {
        ScaledAshashatWord(scale: scale, axis: axis, reference: self)
    }
}
