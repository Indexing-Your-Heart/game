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

extension JensonTimeline {
    static func initializeClass() {
        let classInfo = ClassInfo<JensonTimeline>(name: StringName("\(JensonTimeline.self)"))
        classInfo.registerSignal(name: JensonTimeline.timelineFinishedSignalName)
        classInfo.registerFilePicker(named: "script_path",
                                     allowedTypes: [.jenson],
                                     getter: JensonTimeline._getVariant_script,
                                     setter: JensonTimeline._setVariant_script)

        classInfo.addPropertyGroup(name: "Debugging", prefix: "debug")
        classInfo.registerCheckbox(named: "display_commentary",
                                   prefix: "debug",
                                   getter: JensonTimeline._getVariant_displayCommentary,
                                   setter: JensonTimeline._setVariant_displayCommentary)
    }
}
