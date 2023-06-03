//
//  ProtractorRecognizer+FileAccess.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/20/23.
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
import Protractor
import SwiftGodot

public extension ProtractorRecognizer {
    /// Inserts a series of templates by decoding and transforming a configuration file located in the bundle's
    /// resources.
    /// - Parameter configResourceName: The name of the resource to load and decode.
    /// - Parameter bundle: The bundle to find the resource in.
    func insertTemplates(reading path: String) throws {
        let result = try ProtractorTemplateCodable.load(resourcePath: path)
        insertTemplates(from: result.map { configTemplate in
            ProtractorTemplate(from: configTemplate,
                               accountsForOrientation: self.orientationSensitive,
                               resampledBy: self.resampling)
        })
    }
}
