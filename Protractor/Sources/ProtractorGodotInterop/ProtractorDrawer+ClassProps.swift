//
//  ProtractorDrawer+ClassProps.swift
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

import SwiftGodot

extension ProtractorDrawer {
    static func initializeClass() {
        let classInfo = ClassInfo<ProtractorDrawer>(name: "ProtractorDrawer")

        // MARK: Signal Registration

        let recognizedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: StringName("gesture"),
                     className: StringName("\(ProtractorDrawer.self)"),
                     hint: .typeString,
                     hintStr: "The gesture pattern that was recognized.",
                     usage: .default)
        ]
        classInfo.registerSignal(name: recognizedSignalName, arguments: recognizedSignalProps)

        // MARK: Property Registration

        classInfo.addPropertyGroup(name: "Recognizer", prefix: "recognizer_")

        classInfo.registerFilePicker(named: "template",
                                     allowedTypes: [.json],
                                     prefix: "recognizer",
                                     getter: ProtractorDrawer.getRecognizerTemplates,
                                     setter: ProtractorDrawer.setRecognizerTemplate)
        classInfo.registerCheckbox(named: "orientation_sensitive",
                                   prefix: "recognizer",
                                   getter: ProtractorDrawer.getRecognizerOrientationSensitivity,
                                   setter: ProtractorDrawer.setRecognizerOrientationSensitiviy)

        classInfo.addPropertyGroup(name: "Debug", prefix: "debug_")
        classInfo.registerCheckbox(named: "print_path",
                                   prefix: "debug",
                                   getter: ProtractorDrawer.getDebugPrintPaths,
                                   setter: ProtractorDrawer.setDebugPrintPaths)
    }
}
