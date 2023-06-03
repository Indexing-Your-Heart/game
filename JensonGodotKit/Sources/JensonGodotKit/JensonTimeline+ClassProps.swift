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
        classInfo.registerFilePicker(named: "script_path",
                                     allowedTypes: [.jenson],
                                     getter: JensonTimeline.getScriptPath,
                                     setter: JensonTimeline.setScriptPath)
    }()

    func getScriptPath(args _: [Variant]) -> Variant? {
        return Variant(stringLiteral: script ?? "")
    }

    func setScriptPath(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "script_path", in: args) { arg in
            script = String(arg)
            loadScript()
        }
    }
}
