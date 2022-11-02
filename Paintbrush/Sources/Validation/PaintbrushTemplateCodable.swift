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

/// A struct that represents a template configuration.
struct PaintbrushTemplateCodable: Decodable {
    /// The template's name.
    var name: String

    /// The template's path as a nested array of integers.
    var path: [[Int]]

    /// Converts the path into an array of Paintbrush points.
    func points() -> [PaintbrushPoint] {
        path.compactMap { array in
            guard let first = array.first, let last = array.last else { return PaintbrushPoint.zero }
            return PaintbrushPoint(x: Double(first), y: Double(last))
        }
    }
}
