//
//  EnvironmentTestbench.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 2/26/22.
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
import SpriteKit
import XCTest

@testable import Indexing_Your_Heart

final class EnvironmentTestbench: XCTestCase {
    var environment: GameEnvironment?
    var view: SKView?

    override func setUpWithError() throws {
        environment = GameEnvironment(stageNamed: "Stage1")
        view = SKView(frame: .zero)
        view?.presentScene(environment)
    }

    override func tearDownWithError() throws {
        environment = nil
        view = nil
    }

    func testEnvironmentIsIntialized() throws {
        testInEnvironment { env in
            [env.player, env.tilemap, env.walkingLayer].forEach { node in
                XCTAssertNotNil(node)
            }
            XCTAssertNotEqual(env.walkableTiles, [])
        }
    }

    func testPathfindingChangesPlayerPosition() throws {
        testInEnvironment { env in
            let previousPosition = env.player?.position
            XCTAssertNotEqual(env.walkableTiles, [])
            let locations = env.walkableTiles.map { tile in
                tile.layer.coordinateForPoint(tile.position)
            }
            let walkingExpectation = XCTestExpectation(description: "Walking")
            if let point = locations.randomElement() {
                env.walkToSpecifiedLocation(at: point) {
                    walkingExpectation.fulfill()
                }
            }

            self.wait(for: [walkingExpectation], timeout: 30.0)
            XCTAssertNotEqual(env.player?.position, previousPosition)
        }
    }

    func testTutorialNodeDelegations() throws {
        testInEnvironment { env in
            let dismissalExpectation = XCTestExpectation(description: "Bye-bye tutorial node")
            XCTAssertNotNil(env.environmentDelegate?.tutorialNode)
            env.environmentDelegate?.dismissTutorialNode()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                dismissalExpectation.fulfill()
            }
            self.wait(for: [dismissalExpectation], timeout: 10)
            XCTAssertNil(env.environmentDelegate?.tutorialNode)
        }
    }

    func testInEnvironment(testCase: @escaping (GameEnvironment) throws -> Void) rethrows {
        guard let environment else { return XCTFail("Game environment has not been initialized.") }
        try testCase(environment)
    }
}
