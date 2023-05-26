//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/25/23.
//

import Foundation
import Protractor
import SwiftGodot

extension ProtractorRecognizer {
    /// Inserts a series of templates by decoding and transforming a configuration file located in the bundle's
    /// resources.
    /// - Parameter configResourceName: The name of the resource to load and decode.
    /// - Parameter bundle: The bundle to find the resource in.
    public func insertTemplates(reading path: String) throws {
        let result = try ProtractorTemplateCodable.load(resourcePath: path)
        self.insertTemplates(from: result.map { configTemplate in
            ProtractorTemplate(from: configTemplate,
                               accountsForOrientation: self.orientationSensitive,
                               resampledBy: self.resampling)
        })
    }
}
