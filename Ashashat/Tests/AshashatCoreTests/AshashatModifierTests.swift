//
//  AshashatModifierTests.swift
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

@testable import AshashatCore
import Foundation
import XCTest

final class AshashatModifierTests: XCTestCase {
    func testPluralizationModifier() throws {
        let someThings: some AshashatWord = {
            AshashatPrimitive.thing
                .pluralized(.some)
        }()

        XCTAssertTrue(someThings is PluralizedAshashatWord<AshashatPrimitive>)
        XCTAssertEqual(String(ashashatWord: someThings), "[iʔaʃaʃatasa]")

        let nothing: some AshashatWord = {
            AshashatPrimitive.thing
                .pluralized(.none)
        }()

        XCTAssertTrue(nothing is PluralizedAshashatWord<AshashatPrimitive>)
        XCTAssertEqual(String(ashashatWord: nothing), "[i:ʔaʃaʃat]")
    }

    func testPossessionModifier() throws {
        let word: some AshashatWord = {
            AshashatPrimitive.animal
                .owning()
        }()
        XCTAssertTrue(word is PossessedAshashatWord<AshashatPrimitive>)
        XCTAssertEqual(String(ashashatWord: word), "[k'abupeʃasu:p]")
    }

    func testGrammaticalPersonModifier() throws {
        let yourIdea: some AshashatWord = {
            AshashatPrimitive.idea
                .owning()
                .grammaticalPerson(.second)
        }()
        XCTAssertTrue(yourIdea is GrammaticalPersonAshashatWord<PossessedAshashatWord<AshashatPrimitive>>)
        XCTAssertEqual(String(ashashatWord: yourIdea), "[bik'aʔaʃasu:p]")
    }
}
