//
//  ProtractorRecognitionDelegate.swift
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
import CoreGraphics

public protocol ProtractorRecognitionDelegate: AnyObject {
    associatedtype Point: ProtractorCoordinateRepresentable
    associatedtype Template: ProtractorTemplateRepresentable
    typealias Component = Point.CoordinateComponent

    var templates: [Template] { get set }
    var vectorPath: [Component] { get set }
    func recognize() -> (String, Double)
    func optimalCosineDistance(from vector: [Component], to prime: [Component]) -> Component
}

extension ProtractorRecognitionDelegate {
    func recognize() -> (String, Double) where Template.Component == Point.CoordinateComponent {
        var maxScore = 0.0
        var matchingGestureName = ""
        for template in templates {
            let distance = optimalCosineDistance(from: vectorPath, to: template.vectorPath)
            let score = 1 / Double(distance)
            if score > maxScore {
                maxScore = score
                matchingGestureName = template.name
            }
        }
        return (matchingGestureName, maxScore)
    }
}
