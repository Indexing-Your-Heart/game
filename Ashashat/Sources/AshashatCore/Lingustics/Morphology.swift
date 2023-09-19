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

struct Syllable {
    var content: String
}

extension Syllable: Equatable {}

struct Morpheme {
    var syllables: [Syllable]

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

extension String {
    init(morpheme: Morpheme) {
        self = morpheme.syllables.compactMap { $0.content }.joined()
    }
}
