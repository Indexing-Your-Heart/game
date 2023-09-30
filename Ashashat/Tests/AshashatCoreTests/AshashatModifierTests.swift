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
                .owning { word in
                    word.grammaticalPerson(.second)
                }
        }()
        XCTAssertTrue(
            yourIdea is
            CircumfixedAshashatWord<AshashatPrimitive, GrammaticalPersonAshashatWord<PossessionAshashatWord>>)
        XCTAssertEqual(String(ashashatWord: yourIdea), "[biʔaʃak'asu:p]")
    }

    func testActionModifier() throws {
        let word: some AshashatWord = {
            AshashatPrimitive.idea
                .action(.speakable)
        }()
        XCTAssertTrue(word is ActionableAshashatWord<AshashatPrimitive>)
        XCTAssertEqual(String(ashashatWord: word), "[ʔaʃakasu]")
    }

    func testLogicalConjunctionModifier() throws {
        let unmarkableIdea: some AshashatWord = {
            AshashatPrimitive.idea
                .action(.markable) { action in
                    action.logicalConjunction(using: .not)
                }
        }()
        XCTAssertTrue(
            unmarkableIdea is SuffixedAshashatWord<AshashatPrimitive, LogicalAshashatWord<AshashatActionModifier>>)
        XCTAssertEqual(String(ashashatWord: unmarkableIdea), "[ʔaʃabasukaʔabin]")
    }

    func testScientificDomainModifier() throws {
        let iPad: some AshashatWord = {
            AshashatShape.slab
                .scientificDomain(.electrical)
        }()
        XCTAssertTrue(iPad is ScientificDomainAshashatWord<AshashatShape>)
        XCTAssertEqual(String(ashashatWord: iPad), "[esiʃaʃaku]")
    }

    func testScaleModifier() throws {
        let bigBall: some AshashatWord = {
            AshashatShape.sphere
                .scaled(to: .large)
        }()
        XCTAssertTrue(bigBall is ScaledAshashatWord<AshashatShape>)
        XCTAssertEqual(String(ashashatWord: bigBall), "[ʔilinaʃi]")

        let longSlab: some AshashatWord = {
            AshashatShape.slab
                .scaled(to: .medium, axis: .length)
        }()
        XCTAssertTrue(longSlab is ScaledAshashatWord<AshashatShape>)
        XCTAssertEqual(String(ashashatWord: longSlab), "[siʃaʃek'aʃa]")
    }
}
