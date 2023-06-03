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

import Foundation

/// A class that handles gesture recognition using the Protractor algorithm.
public class ProtractorRecognizer: ProtractorRecognitionDelegate {
    /// The representation of a point.
    public typealias Point = ProtractorPoint

    /// The representation of a template.
    public typealias Template = ProtractorTemplate

    /// Whether to account for orientation when matching gestures.
    public var orientationSensitive: Bool { _orientationSensitive }

    /// The number of points to resample both the vector path and each template by.
    public var resampling: Int { _resampling }

    /// The list of templates the recognizer is aware of.
    public var templates: [ProtractorTemplate] { _templates }

    /// The prepared path that the recognizer will attempt to match among a list of templates.
    ///
    /// When calling ``setPath(_:orientationSensitive:)`` or ``init(from:accountForOrientation:resampledBy:)``, the path
    /// will be resampled and vectorized automatically.
    public var vectorPath: [Component] { _vectorPath }

    private var _templates = [ProtractorTemplate]()
    private var _vectorPath = [Double]()
    private var _resampling: Int

    private var _orientationSensitive: Bool = false

    /// Creates a blank recognizer.
    /// - Parameter orientationSensitive: Whether the recognizer should account for orientation when recognizing a
    ///   gesture. Defaults to false.
    /// - Parameter resampleRate: The number of points that a vector path should be resampled to for the best possible
    ///   results. Defaults to 16.
    public init(accountForOrientation orientationSensitive: Bool = false, resampledBy resampleRate: Int = 16) {
        _orientationSensitive = orientationSensitive
        _resampling = resampleRate
    }

    /// Creates a recognizer with a prefilled path.
    ///
    /// When constructing a recognizer with a predefined path, the recognizer will automatically resample and vectorize
    /// the path, taking into account orientation and the resample rate defined.
    ///
    /// - Parameter path: The vector path that will be recognized.
    /// - Parameter orientationSensitive: Whether the recognizer should account for orientation when recognizing a
    ///   gesture. Defaults to false.
    /// - Parameter resampleRate: The number of points that a vector path should be resampled to for the best possible
    ///   results. Defaults to 16.
    public init(from path: ProtractorPath,
                accountForOrientation orientationSensitive: Bool = false,
                resampledBy resampling: Int = 16)
    {
        _resampling = resampling
        _orientationSensitive = orientationSensitive
        _vectorPath = path.resampled(count: self.resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
    }

    /// Sets the path to be recognized, resampling it and vectorizing it automatically.
    /// - Parameter path: The path that will be recognized.
    /// - Parameter orientationSensitive: Whether the recognizer should account for orientation.
    public func setPath(_ path: ProtractorPath, orientationSensitive: Bool) {
        _orientationSensitive = orientationSensitive
        _vectorPath = path.resampled(count: resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
    }

    /// Removes all current templates available from the recognizer.
    public func dropTemplates() {
        _templates.removeAll()
    }

    /// Inserts a series of templates into the recognizer.
    /// - Parameter templates: An array of templates to include in the recognizer.
    public func insertTemplates(from templates: [ProtractorTemplate]) {
        _templates.append(contentsOf: templates)
    }

    /// Inserts a series of templates by decoding and transforming a configuration file located in the bundle's
    /// resources.
    /// - Parameter configResourceName: The name of the resource to load and decode.
    /// - Parameter bundle: The bundle to find the resource in.
    public func insertTemplates(reading configResourceName: String, in bundle: Bundle = .main) throws {
        guard let path = bundle.path(forResource: configResourceName, ofType: "json") else {
            return
        }

        let result = try ProtractorTemplateCodable.load(resourceURL: URL(filePath: path))
        _templates.append(contentsOf: result.map { configTemplate in
            ProtractorTemplate(from: configTemplate,
                               accountsForOrientation: self.orientationSensitive,
                               resampledBy: self.resampling)
        })
    }
}
