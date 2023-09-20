//
//  Morphology.swift
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

/// A structure representing an atomic portion of a morpheme.
///
/// Morphemes can contain muliple syllables and aren't necessarily the best choice for representing atomic linguistic
/// content. This structure is used to represent that data in a succinct fashion.
///
/// Typically, syllables aren't constructed on their own. Rather, they are generated when creating a linguistic
/// representable.
public struct Syllable {
    /// The string content representing this syllable.
    public var content: String

    init(content: String) {
        self.content = content
    }
}

extension Syllable: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.content = value
    }
}

extension Syllable: Equatable {}

/// A protocol that represents linguistic content that can be modified.
public protocol LinguisticRepresentable {
    /// A lingustic representable that acts as a bound morpheme.
    ///
    /// Bound morphemes cannot stand on their own and must be accompanied with a free morpheme. This type is generally
    /// used when altering a free morpheme, such as ``prefixed(by:)`` or ``circumfixed(by:)``.
    associatedtype BoundMorpheme: LinguisticRepresentable

    /// A linguistic representable that acts as a combined morpheme.
    ///
    /// A compund morpheme contains at least one free morpheme and one or more bound morphemes.
    associatedtype Compound: LinguisticRepresentable

    /// The syllables that make up this linguistic representable.
    var syllables: [Syllable] { get set }

    /// Creates a new representable with a prefix applied.
    /// - Parameter prefix: The prefix that will be prefixed to the current representable.
    func prefixed(by prefix: BoundMorpheme) -> Compound

    /// Creates a new representable with a suffix applied.
    /// - Parameter suffix: The suffix that will be appended to the current representable.
    func suffixed(by suffix: BoundMorpheme) -> Compound

    /// Creates a new representable with a circumfix applied.
    ///
    /// This method assumes that only the first syllable will be added to the front, with the remaining syllables
    /// being appended to the end of the morpheme.
    ///
    /// - Parameter circumfix: The circumfix that will wrap the current representable.
    func circumfixed(by circumfix: BoundMorpheme) -> Compound

    /// Creates a new representable with an infix applied.
    ///
    /// This method assumes that the bound morpheme will be inserted after the first syllable. Calling 
    /// ``circumfixed(by:)`` on the bound morpheme to its root achieves the same effect:
    ///
    /// ```swift
    /// bound.circumfixed(by: root)
    /// ```
    /// - Parameter infix: The infix that will be inserted into the current representable.
    func infixed(by infix: BoundMorpheme) -> Compound
}

public extension String {
    /// Creates a string from a linguistic representable, using the syllables as the string content.
    ///
    /// This is typically used to convert the abstract linguistic content into a string that can be rendered to the
    /// user, such as a localizable string or finalized conlang word.
    /// - Parameter linguisticRepresentable: The linguistic representable used to create the string.
    init(linguisticRepresentable: any LinguisticRepresentable) {
        self = linguisticRepresentable.syllables.compactMap { $0.content }.joined()
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<T: LinguisticRepresentable>(_ linguisticRepresentable: T) {
        appendLiteral(String(linguisticRepresentable: linguisticRepresentable))
    }
}

struct Morpheme {
    var syllables: [Syllable]
}

extension Morpheme: LinguisticRepresentable {
    typealias BoundMorpheme = Morpheme
    typealias Compound = Morpheme

    func prefixed(by morpheme: Morpheme) -> Morpheme {
        Morpheme(syllables: morpheme.syllables + self.syllables)
    }

    func suffixed(by morpheme: Morpheme) -> Morpheme {
        Morpheme(syllables: self.syllables + morpheme.syllables)
    }

    func circumfixed(by morpheme: Morpheme) -> Morpheme {
        guard let firstCircumfix = morpheme.syllables.first else { return self }
        let remainingCircumfix = Array(morpheme.syllables.dropFirst())
        return Morpheme(syllables: [firstCircumfix] + self.syllables + remainingCircumfix)
    }

    func infixed(by morpheme: Morpheme) -> Morpheme {
        morpheme.circumfixed(by: self)
    }
}

extension Morpheme: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Syllable

    init(arrayLiteral elements: ArrayLiteralElement...) {
        self.syllables = elements
    }
}

extension Morpheme: ExpressibleByStringLiteral {
    private static func stripIPAMarkingBraces(_ value: String) -> String {
        if value.hasPrefix("["), value.hasSuffix("]") {
            return String(value.dropFirst().dropLast())
        }
        return value
    }

    init(stringLiteral value: StringLiteralType) {
        let components = Morpheme.stripIPAMarkingBraces(value).split(separator: ".").map(String.init)
        self.syllables = components.map(Syllable.init(content:))
    }
}
