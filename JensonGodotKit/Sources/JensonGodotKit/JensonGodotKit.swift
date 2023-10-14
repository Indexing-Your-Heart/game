//
//  JensonGodotKit.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/29/23.
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

@GodotMain
class LibJensonGodotKit: GodotExtensionDelegate {
    func extensionDidInitialize(at _: GDExtension.InitializationLevel) {
        register(type: JensonTimeline.self)
    }
}
