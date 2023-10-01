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

import Foundation
import JensonKit
import SwiftGodot
import UniformTypeIdentifiers

extension UTType {
    static var jenson = UTType(filenameExtension: "jenson")!
}

extension JensonTimeline {
    static var initClass: Void = {
        let classInfo = ClassInfo<JensonTimeline>(name: StringName("\(JensonTimeline.self)"))
        classInfo.registerSignal(name: JensonTimeline.timelineFinishedSignalName)
        classInfo.registerFilePicker(named: "script_path",
                                     allowedTypes: [.jenson],
                                     getter: JensonTimeline.getScriptPath,
                                     setter: JensonTimeline.setScriptPath)

        classInfo.addPropertyGroup(name: "Debugging", prefix: "debug")
        classInfo.registerCheckbox(named: "display_commentary",
                                   prefix: "debug",
                                   getter: JensonTimeline.getDebugCommentary,
                                   setter: JensonTimeline.setDebugCommentary)
    }()

    func getScriptPath(args _: [Variant]) -> Variant? {
        Variant(stringLiteral: script ?? "")
    }

    func setScriptPath(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "script_path", in: args) { arg in
            script = String(arg)
            if !Engine.isEditorHint() {
                loadScript()
            }
        }
    }

    func getDebugCommentary(args _: [Variant]) -> Variant? {
        Variant(displayCommentary)
    }

    func setDebugCommentary(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "display_commentary", in: args) { arg in
            GD.print(Bool(arg))
            displayCommentary = Bool(arg) ?? false
        }
    }
}
