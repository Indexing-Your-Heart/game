//
//  JensonReader+FileAccess.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/30/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import JensonKit
import SwiftGodot

public extension JensonReader {
    /// Creates an instance of a Jenson reader from a Godot resource path.
    /// - Parameter path: The path to the resource file that contains the Jenson script.
    convenience init?(resource path: String) throws {
        guard let file = FileAccess.open(path: path, flags: .read) else { return nil }
        let contents = file.getAsText()
        file.close()
        guard let data = contents.data(using: .utf8) else { throw GodotError.errFileCorrupt }
        self.init(data)
    }
}

public extension JensonWriter {
    /// Writes the Jenson file to a specified Godot resource path.
    /// - Parameter path: The path to the file to write to.
    func write(resource path: String) throws {
        let data = try data()
        let encodedString = data.base64EncodedString(options: .lineLength64Characters)

        let fileAccess = FileAccess.open(path: path, flags: .write)
        fileAccess?.storeString(encodedString)
        fileAccess?.close()
    }
}
