//
//  MorphologyTests.swift
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

@testable import AshashatCore
import Foundation
import XCTest

final class MorphologyTests: XCTestCase {
    let root: Morpheme = "pro.cess"

    func testSyllableParsing() throws {
        let expectedSyllables: [Syllable] = ["un", "bel", "ie", "va", "ble"]
        let morpheme: Morpheme = "un.bel.ie.va.ble"
        XCTAssertEqual(morpheme.syllables, expectedSyllables)
    }

    func testSyllableParsingWithIPA() throws {
        let expectedSyllables: [Syllable] = ["ʔa", "ʃa", "ʃat"]
        let morpheme: Morpheme = "[ʔa.ʃa.ʃat]"
        XCTAssertEqual(morpheme.syllables, expectedSyllables)
    }

    func testPrefixing() throws {
        let prefixedValue = root.prefixed(by: "pre")
        XCTAssertEqual(String(linguisticRepresentable: prefixedValue), "preprocess")
    }

    func testSuffixing() throws {
        let suffixedValue = root.suffixed(by: "ed")
        XCTAssertEqual(String(linguisticRepresentable: suffixedValue), "processed")
    }

    func testCircumfixing() throws {
        let circumfixedValue = root.circumfixed(by: "un.able")
        XCTAssertEqual(String(linguisticRepresentable: circumfixedValue), "unprocessable")
    }

    func testInfixing() throws {
        let infixedValue = root.circumfixed(by: "un.able").infixed(by: "fu.cking")
        XCTAssertEqual(String(linguisticRepresentable: infixedValue), "unfuckingprocessable")
    }
}
