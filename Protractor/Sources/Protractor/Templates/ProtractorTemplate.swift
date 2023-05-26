//
//  ProtractorTemplate.swift
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

/// A structure that represents a template for use in the gesture recognition algorithms.
public struct ProtractorTemplate {
    public typealias Point = ProtractorPoint

    /// The name of the gesture in the template.
    public var name: String

    /// An array of double values that represent the vector path of the gesture.
    public var vectorPath: [Double]

    /// Creates a new instance of a template.
    /// - Parameter name: The new name of the gesture.
    /// - Parameter vectorPath: The list of double that represent the gesture's vector path. This path should already be
    ///   vectorized and resampled.
    public init(name: String, vectorPath: [Double]) {
        self.name = name
        self.vectorPath = vectorPath
    }

    /// Creates a template from a codable value.
    /// - Parameter configuration: The codable configuration that contains the template.
    /// - Parameter orientationSensitive: Whether orientation should be taken into account when generating the
    ///   vector path. Defaults to false.
    /// - Parameter resampling: The number of points that the vectorized path should contain. Defaults to 16.
    public init(from configuration: ProtractorTemplateCodable,
                accountsForOrientation orientationSensitive: Bool = false,
                resampledBy resampling: Int = 16)
    {
        let name = configuration.name
        let vectorPath = ProtractorPath(points: configuration.points())
            .resampled(count: resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
        self.init(name: name, vectorPath: vectorPath)
    }
}

extension ProtractorTemplate: ProtractorTemplateRepresentable {
    public typealias Component = Double
}
