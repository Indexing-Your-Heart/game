//
//  Distance.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

@testable import CranberrySprite
import Foundation
import XCTest

class CranberryDistanceTests: XCTestCase {
    let firstPoint = CGPoint(x: 0, y: 0)
    let secondPoint = CGPoint(x: 5, y: 5)

    func testDistanceCGPointImpl() throws {
        let distance = secondPoint.distance(between: firstPoint)
        XCTAssertTrue((7.0 ..< 7.1).contains(distance))
    }

    func testManhattanDistanceCGPointImpl() throws {
        let distance = secondPoint.manhattanDistance(to: firstPoint)
        XCTAssertEqual(distance, 10)
    }
}
