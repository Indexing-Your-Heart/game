//
//  JensonTimeline+ClassProps.swift
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
import UniformTypeIdentifiers

extension UTType {
    static var jenson = UTType(filenameExtension: "jenson")!
}

extension JensonTimeline: GodotInspectable {
    static public var inspector: Inspector<JensonTimeline> {
        Inspector {
            FilePicker("script_path", for: [.jenson], property: #autoProperty(object: JensonTimeline.self, "script"))
            Group<JensonTimeline>("Debugging", prefix: "debug") {
                Toggle("display_commentary",
                       property: #autoProperty(object: JensonTimeline.self, "displayCommentary"))
            }
        }
    }
}

extension JensonTimeline {
    static func initializeClass() {
        let classInfo = ClassInfo<JensonTimeline>(name: StringName("\(JensonTimeline.self)"))
        classInfo.registerInspector()
        classInfo.registerSignal(name: JensonTimeline.timelineFinishedSignalName)
    }
}
