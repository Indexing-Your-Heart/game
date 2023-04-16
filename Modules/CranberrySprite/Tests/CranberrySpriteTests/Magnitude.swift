//
//  Magnitude.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

@testable import CranberrySprite
import Foundation
import XCTest

class CranberryMagnitudeTests: XCTestCase {
    let pointA = CGPoint(x: 1, y: 2)
    let pointB = CGPoint(x: 4, y: 3)

    var vector: CGVector {
        CGVector(dx: pointB.x - pointA.x, dy: pointB.y - pointA.y)
    }

    func testMagnitudeIsCorrect() throws {
        let magnitude = vector.magnitude()
        print(magnitude)

        XCTAssertTrue((3.1 ..< 3.2).contains(magnitude))
    }

    func testVectorComparability() throws {
        let zeroVector = CGVector.zero
        XCTAssertEqual(vector > zeroVector, true)
    }
}
