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

import CoreGraphics
import Foundation

/// A delegate that handles recognizing gestures using the Protractor gesture algorithm.
public protocol ProtractorRecognitionDelegate: AnyObject {
    /// A typealias referencing the recognizer's point type.
    associatedtype Point: ProtractorCoordinateRepresentable

    /// A typealias referencing the recognizer's template type.
    associatedtype Template: ProtractorTemplateRepresentable

    /// A typealias referencing the point's component type.
    typealias Component = Point.CoordinateComponent

    /// An array of templates the recognizer will match against.
    var templates: [Template] { get set }

    /// The vectorized path that the recognizer will attempt to recognize.
    var vectorPath: [Component] { get set }

    /// Runs the Protractor algorithm to determine what gesture best represents the vector path.
    /// - Returns: A tuple containing the closest matching template name and the maximum score.
    func recognize() -> (String, Double)

    /// Returns the optimal cosine distance between two vectors.
    /// - Parameter vector: The first vector to get the optimal cosine distance of.
    /// - Parameter prime: The second vector to get the optimal cosine distance of.
    /// - Returns: The optimal cosine distance between the two vectors.
    func optimalCosineDistance(from vector: [Component], to prime: [Component]) -> Component
}

public extension ProtractorRecognitionDelegate {
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

    func optimalCosineDistance(from vector: [Component],
                               to prime: [Component]) -> Component where Template.Component == Point.CoordinateComponent
    {
        var aValue = 0.0
        var bValue = 0.0
        for idx in stride(from: 0, to: vector.count, by: 2) {
            aValue += Double(vector[idx] * prime[idx] + vector[idx + 1] * prime[idx + 1])
            bValue += Double(vector[idx] * prime[idx + 1] - vector[idx + 1] * prime[idx])
        }
        let angle = tan(bValue / aValue)
        let distance = acos(aValue * cos(angle) + bValue * sin(angle))
        return Self.Component(distance)
    }
}
