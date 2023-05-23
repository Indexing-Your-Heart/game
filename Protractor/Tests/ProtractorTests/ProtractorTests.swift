//
//  ProtractorTests.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/2/22.
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
@testable import Protractor
import XCTest

class ProtractorTests: XCTestCase {
    func hundredPoints() -> [ProtractorPoint] {
        var points = [ProtractorPoint]()
        for iter in 1 ... 100 {
            points.append(ProtractorPoint(x: Double(iter), y: Double(iter)))
        }
        return points
    }

    func rectPoints() -> [ProtractorPoint] {
        var points = [ProtractorPoint]()
        let width = 100
        let height = 75

        // Draw vertical
        for idx in 1 ... height {
            points.append(.init(x: Double(1), y: Double(idx)))
        }

        // Draw across
        for idx in 2 ... width {
            points.append(.init(x: Double(idx), y: Double(height)))
        }

        // Draw up
        for idx in (1 ..< height).reversed() {
            points.append(.init(x: Double(width), y: Double(idx)))
        }

        // Draw across to origin
        for idx in (2 ..< width).reversed() {
            points.append(.init(x: Double(idx), y: Double(1)))
        }

        return points
    }

    func testResamplingContainsCorrectNumberOfPoints() throws {
        let points = hundredPoints()
        let path = ProtractorPath(points: points)
        let resampled = path.resampled(count: 16)
        XCTAssertEqual(resampled.count, 16)
    }

    func testVectorizationContainsCorrectNumberOfPoints() throws {
        let points = hundredPoints()
        let path = ProtractorPath(points: points)
        let vector = path.resampled(count: 16).vectorized(accountsForOrientation: false)
        XCTAssertEqual(vector.count, 16 * 2)
    }

    func testRecognizerTemplateLoadsFromConfigurationFile() throws {
        let recogniser = ProtractorRecognizer(from: .init(points: rectPoints()))
        try recogniser.insertTemplates(reading: "templates", in: .module)
        XCTAssertFalse(recogniser.templates.isEmpty)
    }

    func testProtractorFlowWorks() throws {
        let recogniser = ProtractorRecognizer(from: .init(points: rectPoints()))
        try recogniser.insertTemplates(reading: "templates", in: .module)

        let (name, score) = recogniser.recognize()
        XCTAssertEqual(name, "rectangle")
        XCTAssertNotEqual(score, 0.0)
    }
}
