//
//  ProtractorTemplateCodable+FileAccess.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/25/23.
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

public extension ProtractorTemplateCodable {
    /// Creates a codable template from a loadable path in a Godot project.
    /// - Parameter path: The resource path to the template file in Godot that contains the template.
    init?(resourcePath path: String) throws {
        guard let file = FileAccess.open(path: path, flags: .read) else { return nil }
        let contents = file.getAsText()
        file.close()
        guard let data = contents.data(using: .utf8) else { throw GodotError.errFileCorrupt }

        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    /// Creates a list of codable templates from a loadable path in a Godot project.
    /// - Parameter path: The resource path to the template file in Godot to decode.
    static func load(resourcePath path: String) throws -> [Self] {
        guard let file = FileAccess.open(path: path, flags: .read) else { return [] }
        let contents = file.getAsText()
        file.close()
        guard let data = contents.data(using: .utf8) else { throw GodotError.errFileCorrupt }

        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
}
