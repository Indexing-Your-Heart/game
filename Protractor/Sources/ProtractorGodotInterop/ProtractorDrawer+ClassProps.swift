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

import Foundation
import SwiftGodot

extension ProtractorDrawer {
    // FIXME: These values aren't being retained correctly.
    static var initClass: Void = {
        let classInfo = ClassInfo<ProtractorDrawer>(name: "ProtractorDrawer")

        // MARK: Signal Registration
        let recognizedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: StringName("gesture"),
                     className: StringName("\(ProtractorDrawer.self)"),
                     hint: .typeString,
                     hintStr: "The gesture pattern that was recognized.",
                     usage: .propertyUsageDefault)
        ]
        classInfo.registerSignal(name: recognizedSignalName, arguments: recognizedSignalProps)

        // MARK: Property Registration
        classInfo.addPropertyGroup(name: "Recognizer", prefix: "recognizer_")
        let templateArgs = [
            PropInfo(propertyType: .string,
                     propertyName: "Template File",
                     className: StringName("recognizer_protractor_template"),
                     hint: .file,
                     hintStr: "The file containing templates that the reader will pick from.",
                     usage: .propertyUsageDefault)
        ]
        let orientationSensitiveArgs = [
            PropInfo(propertyType: .bool,
                     propertyName: "Orientation Sensitive",
                     className: StringName("recognizer_orientation_sensitive"),
                     hint: .flags,
                     hintStr: "Whether the recognizer should take the orientation into account.",
                     usage: .propertyUsageDefault)
        ]
        let debugPrintPathArgs = [
            PropInfo(propertyType: .bool,
                     propertyName: "Debug Print Path",
                     className: StringName("debug_print_path"),
                     hint: .flags,
                     hintStr: "Whether to print the line drawn for Protractor. Used for template authoring.",
                     usage: .propertyUsageDefault)
        ]

        classInfo.registerMethod(name: "recognizer_set_templates",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: templateArgs,
                                 function: ProtractorDrawer.setRecognizerTemplate)
        classInfo.registerMethod(name: "recognizer_get_templates",
                                 flags: .default,
                                 returnValue: templateArgs[0],
                                 arguments: [],
                                 function: ProtractorDrawer.getRecognizerTemplates)
        let templateProp = PropInfo(propertyType: .string,
                                    propertyName: "recognizer_protractor_template",
                                    className: "ProtractorDrawer",
                                    hint: .file,
                                    hintStr: "*.json",
                                    usage: .propertyUsageDefault)
        classInfo.registerProperty(templateProp, getter: "recognizer_get_templates", setter: "recognizer_set_templates")

        classInfo.registerMethod(name: "recognizer_set_orientation_sensitive",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: orientationSensitiveArgs,
                                 function: ProtractorDrawer.setRecognizerOrientationSensitiviy)
        classInfo.registerMethod(name: "recognizer_get_orientation_sensitive",
                                 flags: .default,
                                 returnValue: orientationSensitiveArgs[0],
                                 arguments: [],
                                 function: ProtractorDrawer.getRecognizerOrientationSensitivity)
        let orientationProp = PropInfo(propertyType: .bool,
                                       propertyName: "recognizer_orientation_sensitive",
                                       className: "ProtractorDrawer",
                                       hint: .flags,
                                       hintStr: "",
                                       usage: .propertyUsageDefault)
        classInfo.registerProperty(orientationProp,
                                   getter: "recognizer_get_orientation_sensitive",
                                   setter: "recognizer_set_orientation_sensitive")

        classInfo.addPropertyGroup(name: "Debugging", prefix: "debug_")

        classInfo.registerMethod(name: "debug_set_print_path",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: debugPrintPathArgs,
                                 function: ProtractorDrawer.setDebugPrintPaths)
        classInfo.registerMethod(name: "debug_get_print_path",
                                 flags: .default,
                                 returnValue: debugPrintPathArgs[0],
                                 arguments: [],
                                 function: ProtractorDrawer.getDebugPrintPaths)
        let debugPrintPathProp = PropInfo(propertyType: .bool,
                                          propertyName: "debug_print_path",
                                          className: "ProtractorDrawer",
                                          hint: .flags,
                                          hintStr: "",
                                          usage: .propertyUsageDefault)
        classInfo.registerProperty(debugPrintPathProp,
                                   getter: "debug_get_print_path",
                                   setter: "debug_set_print_path")

    }()
}
