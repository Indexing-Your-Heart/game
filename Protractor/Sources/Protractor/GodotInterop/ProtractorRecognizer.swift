//
//  PaintbrushRecognizer.swift
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

import SwiftGodot
import Foundation

/// A class that handles gesture recognition using the Protractor algorithm.
public class ProtractorRecognizer: ProtractorRecognitionDelegate {
    public typealias Point = ProtractorPoint
    public typealias Template = ProtractorTemplate

    public var templates = [ProtractorTemplate]()
    public var vectorPath = [Double]()

    /// The number of points to resample both the vector path and each template by.
    private var resampling: Int

    /// Whether to account for orientation when matching gestures.
    private var orientationSensitive: Bool = false

    public init(accountForOrientation orientationSensitive: Bool = false, resampledBy resampleRate: Int = 16) {
        self.orientationSensitive = orientationSensitive
        self.resampling = resampleRate
    }

    public init(
        from path: ProtractorPath,
        accountForOrientation orientationSensitive: Bool = false,
        resampledBy resampling: Int = 16
    ) {
        self.resampling = resampling
        self.orientationSensitive = orientationSensitive
        vectorPath = path.resampled(count: self.resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
    }

    public func setPath(_ path: ProtractorPath, orientationSensitive: Bool) {
        self.orientationSensitive = orientationSensitive
        self.vectorPath = path.resampled(count: self.resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
    }

    public func dropTemplates() {
        self.templates.removeAll()
    }

    /// Inserts a series of templates into the recognizer.
    /// - Parameter templates: An array of templates to include in the recognizer.
    public func insertTemplates(from templates: [ProtractorTemplate]) {
        self.templates.append(contentsOf: templates)
    }

    /// Inserts a series of templates by decoding and transforming a configuration file located in the bundle's
    /// resources.
    /// - Parameter configResourceName: The name of the resource to load and decode.
    /// - Parameter bundle: The bundle to find the resource in.
    public func insertTemplates(reading path: String) throws {
        let result = try ProtractorTemplateCodable.load(resourcePath: path)
        let transformedTemplates = result.map { configTemplate in
            ProtractorTemplate(
                from: configTemplate,
                accountsForOrientation: self.orientationSensitive,
                resampledBy: self.resampling
            )
        }
        templates.append(contentsOf: transformedTemplates)
    }
}
