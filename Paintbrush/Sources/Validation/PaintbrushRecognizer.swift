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

import CoreGraphics
import Foundation

/// A class that handles gesture recognition using the Protractor algorithm.
public class PaintbrushRecognizer: ProtractorRecognitionDelegate {
    public typealias Point = PaintbrushPoint
    public typealias Template = PaintbrushTemplate

    public var templates = [PaintbrushTemplate]()
    public var vectorPath = [Double]()

    /// The number of points to resample both the vector path and each template by.
    private var resampling: Int

    /// Whether to account for orientation when matching gestures.
    private var orientationSensitive: Bool = false

    init(
        from path: PaintbrushPointPath,
        accountForOrientation orientationSensitive: Bool = false,
        resampledBy resampling: Int = 16
    ) {
        self.resampling = resampling
        self.orientationSensitive = orientationSensitive
        vectorPath = path.resampled(count: self.resampling)
            .vectorized(accountsForOrientation: orientationSensitive)
    }

    /// Inserts a series of templates into the recognizer.
    /// - Parameter templates: An array of templates to include in the recognizer.
    func insertTemplates(from templates: [PaintbrushTemplate]) {
        self.templates.append(contentsOf: templates)
    }

    /// Inserts a series of templates by decoding and transforming a configuration file located in the bundle's
    /// resources.
    /// - Parameter configResourceName: The name of the resource to load and decode.
    /// - Parameter bundle: The bundle to find the resource in.
    func insertTemplates(reading configResourceName: String, in bundle: Bundle) {
        guard let path = bundle.path(forResource: configResourceName, ofType: "json") else {
            return
        }
        let fileURL = URL(filePath: path)
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode([PaintbrushTemplateCodable].self, from: Data(contentsOf: fileURL))
            let transformedTemplates = result.map { configTemplate in
                PaintbrushTemplate(
                    from: configTemplate,
                    accountsForOrientation: self.orientationSensitive,
                    resampledBy: self.resampling
                )
            }
            templates.append(contentsOf: transformedTemplates)
        } catch {
            print("Err: \(error)")
        }
    }
}
