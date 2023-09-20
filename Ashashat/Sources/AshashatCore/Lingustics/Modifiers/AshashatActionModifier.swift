//
//  AshashatActionModifier.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/20/23.
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

/// A modifier that represents various actions that can be performed on a word.
///
/// Action modifiers are typically used to describe what can be done with a given word. For example, a _word_ would be
/// considered a "speakable idea".
public enum AshashatActionModifier: AshashatWord {
    /// The word can be acted upon through speech.
    case speakable

    /// The word can be generally marked on, or it can be used to make marks.
    ///
    /// - Note: To specify writing, use ``writeable`` instead.
    case markable

    /// The word can be used to write content, or it has writing on it.
    ///
    /// - Note: For general, non-linguistic markings, use ``markable`` instead.
    case writeable

    /// The word can be crafted or is used to craft something.
    case craftable

    /// The word can be destroyed or is used to destroy something.
    case destroyable

    /// The word can be used to perform or act, such as in a speech, play, or song.
    case performable

    /// The word can be moved or is used to move something.
    case movable

    /// The word can perform a general action, or it is used to perform a general action.
    ///
    /// ### Generic Doable
    /// > Important: Use this modifier if any of the other modifiers cannot accurately describe the word. For example,
    /// > the following describes an idea that can perform an action (or is actionable), but the action itself is
    /// > unclear:
    /// > ```swift
    /// > var doableIdea: some AshashatWord {
    /// >   AshashatPrimitive.idea
    /// >       .action(.doable) // produces [ʔaʃanalu]
    /// > }
    /// > ```
    case doable

    /// The word exists or contributes to something else's existence.
    case existing

    public var word: some LinguisticRepresentable {
        switch self {
        case .speakable:
            Morpheme(stringLiteral: "[ka.su]")
        case .markable:
            Morpheme(stringLiteral: "[ba.bin]")
        case .writeable:
            Morpheme(stringLiteral: "[ba.pen]")
        case .craftable:
            Morpheme(stringLiteral: "[pa.bil]")
        case .destroyable:
            Morpheme(stringLiteral: "[k'a.bi:]")
        case .performable:
            Morpheme(stringLiteral: "[ʃa.su]")
        case .movable:
            Morpheme(stringLiteral: "[ʃa.ku]")
        case .doable:
            Morpheme(stringLiteral: "[na.lu]")
        case .existing:
            Morpheme(stringLiteral: "[na.lu:]")
        }
    }
}

/// An [ʔaʃaʃat] word that has an action associated with it.
///
/// This cannot be constructed on its own, but can be used through ``AshashatWord/action(_:)``.
struct ActionableAshashatWord<Object: AshashatWord>: AshashatWord {
    /// The action associated with the word.
    var action: AshashatActionModifier

    /// The word where the object applies.
    var object: Object

    var word: some LinguisticRepresentable {
        // I swear to Obel, if I have to type another force cast...
        object.word
            .suffixed(by: action.word as! Object.Word.BoundMorpheme, // swiftlint:disable:this force_cast
                      repairingWith: .ashashat)
    }
}

public extension AshashatWord {
    /// Marks an associated action with a word.
    ///
    /// Action modifiers are typically used to denote that a word can either perform an action type on its own, or it
    /// contributes to something else that can perform that action type.
    ///
    /// For example, the following produces the word _word_, or a "speakable idea":
    /// ```swift
    /// var word: some AshashatWord {
    ///     AshashatPrimitive.idea
    ///         .action(.speakable) // produces [ʔaʃakasu]
    /// }
    /// ```
    ///
    /// Action modifiers are typically applied as suffixes to primitives and other modifiers.
    /// 
    /// - Parameter action: The action to associate with the current word.
    func action(_ action: AshashatActionModifier) -> some AshashatWord {
        ActionableAshashatWord(action: action, object: self)
    }
}
