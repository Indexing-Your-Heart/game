//
//  CaslonTestbench.swift
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

import XCTest
import SpriteKit
import JensonKit
@testable import Indexing_Your_Heart

final class CaslonTestbench: XCTestCase {
    var vnScene: CaslonScene?
    var view: SKView?

    override func setUpWithError() throws {
        vnScene = CaslonScene(fileNamed: "Caslon Scene")
        vnScene?.loadScript(named: "ch01-mise-en-abyme")
        view = SKView(frame: .zero)
        view?.presentScene(vnScene)
    }

    override func tearDownWithError() throws {
        vnScene = nil
        view = nil
    }

    func testCaslonSceneIsInitialized() throws {
        testInCaslonScene { scene in
            XCTAssertNotEqual(scene.timeline, [])
            [scene.whoLabel, scene.whatLabel].forEach { node in
                XCTAssertNotNil(node)
            }
        }
    }

    func testCaslonSceneAppliesDialogue() throws {
        testInCaslonScene { scene in
            if let dialogue = scene.timeline.first(where: { $0.type == .dialogue }) {
                emulateNextEvent(with: dialogue)
                XCTAssertEqual(scene.whoLabel?.text, dialogue.who)
                XCTAssertEqual(scene.whatLabel?.text, dialogue.what)
            }
        }
    }

    func testCaslonSceneAppliesChoiceMenus() throws {
        testInCaslonScene { scene in
            if let choice = scene.timeline.first(where: { $0.type == .question }) {
                emulateNextEvent(with: choice)
                XCTAssertNotEqual(scene.options, [])
                XCTAssertEqual(scene.choiceMenu?.children.count, scene.options.count)

                let names = scene.choiceMenu?.children.map { $0.name?.replacingOccurrences(of: "choice:", with: "") }
                XCTAssertEqual(names, scene.options.map(\.name))
            }
        }
    }

    func testInCaslonScene(testCase: (CaslonScene) throws -> Void) rethrows {
        guard let vnScene else { return XCTFail("Caslon scene isn't initialized.") }
        try testCase(vnScene)
    }

    func emulateNextEvent(with event: JensonEvent) {
        guard let vnScene else { return }
        vnScene.willDisplayNewEvent(event: event)
        vnScene.didDisplayNewEvent(event: event)
    }
}
