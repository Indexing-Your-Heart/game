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

import Algorithms
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
    /// Creates a syllable from a string literal.
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
    /// used when altering a free morpheme, such as ``prefixed(by:repairingWith:)-7deeh`` or
    /// ``circumfixed(by:repairingWith:)-5als7``.
    associatedtype BoundMorpheme: LinguisticRepresentable

    /// A linguistic representable that acts as a combined morpheme.
    ///
    /// A compund morpheme contains at least one free morpheme and one or more bound morphemes.
    associatedtype Compound: LinguisticRepresentable

    /// The syllables that make up this linguistic representable.
    var syllables: [Syllable] { get set }

    /// Creates a new representable with a prefix applied.
    /// - Parameter prefix: The prefix that will be prefixed to the current representable.
    /// - Parameter strategy: A closure that returns an array of repaired syllables, if repair strategies need to be
    ///   applied. The first two arguments contain the syllables, and the final argument indicates whether the pair
    ///   sits at the end of the morpheme.
    func prefixed(by prefix: BoundMorpheme,
                  repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Compound

    /// Creates a new representable with a suffix applied.
    /// - Parameter suffix: The suffix that will be appended to the current representable.
    /// - Parameter strategy: A closure that returns an array of repaired syllables, if repair strategies need to be
    ///   applied. The first two arguments contain the syllables, and the final argument indicates whether the pair
    ///   sits at the end of the morpheme.
    func suffixed(by suffix: BoundMorpheme,
                  repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Compound

    /// Creates a new representable with a circumfix applied.
    ///
    /// This method assumes that only the first syllable will be added to the front, with the remaining syllables
    /// being appended to the end of the morpheme.
    ///
    /// - Parameter circumfix: The circumfix that will wrap the current representable.
    /// - Parameter strategy: A closure that returns an array of repaired syllables, if repair strategies need to be
    ///   applied. The first two arguments contain the syllables, and the final argument indicates whether the pair
    ///   sits at the end of the morpheme.
    func circumfixed(by circumfix: BoundMorpheme,
                     repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Compound

    /// Creates a new representable with an infix applied.
    ///
    /// This method assumes that the bound morpheme will be inserted after the first syllable. Calling
    /// ``circumfixed(by:repairingWith:)-5als7`` on the bound morpheme to its root achieves the same effect:
    ///
    /// ```swift
    /// bound.circumfixed(by: root)
    /// ```
    /// - Parameter infix: The infix that will be inserted into the current representable.
    /// - Parameter strategy: A closure that returns an array of repaired syllables, if repair strategies need to be
    ///   applied. The first two arguments contain the syllables, and the final argument indicates whether the pair
    ///   sits at the end of the morpheme.
    func infixed(by infix: BoundMorpheme,
                 repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Compound
}

public extension LinguisticRepresentable {
    /// Creates a new representable with a prefix applied.
    /// - Parameter prefix: The prefix that will be prefixed to the current representable.
    /// - Parameter strategy: A phonological repair strategy to use. Defaults to the ``DefaultRepairStrategy``.
    func prefixed(by prefix: BoundMorpheme,
                  repairingWith strategy: PhonotacticRepairStrategy = .default) -> Compound {
        self.prefixed(by: prefix, repairingWith: strategy.apply)
    }

    /// Creates a new representable with a suffix applied.
    /// - Parameter suffix: The suffix that will be appended to the current representable.
    /// - Parameter strategy: A phonological repair strategy to use. Defaults to the ``DefaultRepairStrategy``.
    func suffixed(by suffix: BoundMorpheme,
                  repairingWith strategy: PhonotacticRepairStrategy = .default) -> Compound {
        self.suffixed(by: suffix, repairingWith: strategy.apply)
    }

    /// Creates a new representable with a circumfix applied.
    ///
    /// This method assumes that only the first syllable will be added to the front, with the remaining syllables
    /// being appended to the end of the morpheme.
    ///
    /// - Parameter circumfix: The circumfix that will wrap the current representable.
    /// - Parameter strategy: A phonological repair strategy to use. Defaults to the ``DefaultRepairStrategy``.
    func circumfixed(by circumfix: BoundMorpheme,
                     repairingWith strategy: PhonotacticRepairStrategy = .default) -> Compound {
        self.circumfixed(by: circumfix, repairingWith: strategy.apply)
    }

    /// Creates a new representable with an infix applied.
    ///
    /// This method assumes that the bound morpheme will be inserted after the first syllable. Calling
    /// ``circumfixed(by:repairingWith:)-6xeup`` on the bound morpheme to its root achieves the same effect:
    ///
    /// ```swift
    /// bound.circumfixed(by: root)
    /// ```
    /// - Parameter infix: The infix that will be inserted into the current representable.
    /// - Parameter strategy: A phonological repair strategy to use. Defaults to the ``DefaultRepairStrategy``.
    func infixed(by infix: BoundMorpheme,
                 repairingWith strategy: PhonotacticRepairStrategy = .default) -> Compound {
        self.infixed(by: infix, repairingWith: strategy.apply)
    }
}

/// A protocol that provides a phonotactic repair strategy between syllables.
///
/// Some languages have phonotactic rules for how syllables interact with each other in a morpheme. A repair strategy
/// defines an approach for how to repair syllables to match these rules.
///
/// A default strategy is provided with the ``DefaultRepairStrategy``, which does no modifications.
public protocol PhonotacticRepairStrategy {
    /// Applies the repair strategy to the current two syllables.
    /// - Parameter first: The first syllable in the pair that may need to be repaired.
    /// - Parameter second: The second syllable in the pair that may need to be repaired.
    /// - Parameter endOfWord: Whether the syllable pair appears at the end of the word. This is typically used to
    ///   ignore a repair strategy if it doesn't apply to the ending.
    func apply(_ first: Syllable, _ second: Syllable, endOfWord: Bool) -> [Syllable]
}

/// The default repair strategy, where no modifications are made.
public struct DefaultRepairStrategy: PhonotacticRepairStrategy {
    public func apply(_ first: Syllable, _ second: Syllable, endOfWord _: Bool) -> [Syllable] {
        [first, second]
    }
}

extension PhonotacticRepairStrategy where Self == DefaultRepairStrategy {
    /// The default repair strategy.
    public static var `default`: PhonotacticRepairStrategy { DefaultRepairStrategy() }
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

    static func applyRepairStrategy(_ strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable],
                                    to syllableSet: [Syllable]) -> [Syllable] {
        let chunks = syllableSet.chunks(ofCount: 2)
        return chunks.enumerated().flatMap { (index, slice) in
            guard let first = slice.first else { return Array(slice) }
            if slice.count > 1, let last = slice.last {
                return strategy(first, last, index == chunks.count - 1)
            }
            return strategy(first, first, true).dropLast()
        }
    }

    func prefixed(
        by morpheme: Morpheme,
        repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Morpheme {
        Morpheme(syllables: Morpheme.applyRepairStrategy(strategy, to: morpheme.syllables + self.syllables))
    }

    func suffixed(
        by morpheme: Morpheme,
        repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Morpheme {
        Morpheme(syllables: Morpheme.applyRepairStrategy(strategy, to: self.syllables + morpheme.syllables))
    }

    func circumfixed(
        by morpheme: Morpheme,
        repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Morpheme {
        guard let firstCircumfix = morpheme.syllables.first else { return self }
        let remainingCircumfix = Array(morpheme.syllables.dropFirst())
        return Morpheme(
            syllables: Morpheme.applyRepairStrategy(strategy,
                                                    to: [firstCircumfix] + self.syllables + remainingCircumfix)
        )
    }

    func infixed(
        by morpheme: Morpheme,
        repairingWith strategy: @escaping (Syllable, Syllable, Bool) -> [Syllable]) -> Morpheme {
        morpheme.circumfixed(by: self, repairingWith: strategy)
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
