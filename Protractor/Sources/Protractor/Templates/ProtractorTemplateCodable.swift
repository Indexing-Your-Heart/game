//
//  PaintbrushTemplateCodable.swift
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
import SwiftGodot

/// A struct that represents a template configuration.
public struct ProtractorTemplateCodable: Decodable {
    /// The template's name.
    public var name: String

    /// The template's path as a nested array of integers.
    public var path: [[Int]]

    /// Converts the path into an array of Paintbrush points.
    public func points() -> [ProtractorPoint] {
        path.compactMap { array in
            guard let first = array.first, let last = array.last else { return .zero }
            return ProtractorPoint(x: Double(first), y: Double(last))
        }
    }
}

extension ProtractorTemplateCodable {
    /// Creates a codable template from a loadable path in a Godot project.
    /// - Parameter path: The resource path to the template file in Godot that contains the template.
    public init(resourcePath path: String) throws {
        let file = FileAccess.open(path: path, flags: .read)
        let contents = file.getAsText()
        file.close()
        guard let data = contents.data(using: .utf8) else { throw GodotError.errFileCorrupt }

        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    /// Creates a list of codable templates from a loadable path in a Godot project.
    /// - Parameter path: The resource path to the template file in Godot to decode.
    public static func load(resourcePath path: String) throws -> [Self] {
        let file = FileAccess.open(path: path, flags: .read)
        let contents = file.getAsText()
        file.close()
        guard let data = contents.data(using: .utf8) else { throw GodotError.errFileCorrupt }

        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }

    /// Creates a list of codable templates from a loadable path from a URL.
    /// - Parameter url: The URL to the template to decode.
    public static func load(resourceURL url: URL) throws -> [Self] {
        guard let data = try String(contentsOf: url).data(using: .utf8) else { throw CocoaError(.fileReadUnknown) }
        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
}
