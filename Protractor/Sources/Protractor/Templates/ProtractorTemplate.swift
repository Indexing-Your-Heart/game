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

    public var name: String
    public var vectorPath: [Double]

    public init(name: String, vectorPath: [Double]) {
        self.name = name
        self.vectorPath = vectorPath
    }

    init(
        from configuration: ProtractorTemplateCodable,
        accountsForOrientation orientationSensitive: Bool = false,
        resampledBy resampling: Int = 16
    ) {
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
