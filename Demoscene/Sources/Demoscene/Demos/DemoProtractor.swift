//
//  DemoProtractor.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/07/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import ProtractorGodotInterop
import SwiftGodot

@NativeHandleDiscarding
class DemoProtractor: DemoBaseNode {
    @SceneTree(path: "ProtractorDrawer") var drawer: ProtractorDrawer?
    @SceneTree(path: "CanvasLayer/Label") var debugLabel: Label?

    required init() {
        DemoProtractor.initializeClass()
        super.init()
    }

    override func _ready() {
        super._ready()
        _ = drawer?.connect(signal: "recognized", callable: #methodName(templateRecognized))
        LibDemoscene.logger.warning(
            """
            Protractor has been deprecated and will be removed.

            Future puzzles should be using [ʔaʃaʃat] instead.
            """
        )
    }

    @Callable
    func templateRecognized(_ template: String) {
        debugLabel?.text = """
        [DEBUG]: Best guess is: \(template)
        Draw a line on the panel to get a gesture name.
        """
    }
}

extension DemoProtractor {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(DemoProtractor.self)")
        let classInfo = ClassInfo<DemoProtractor>(name: className)

        let recognizedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: StringName("template"),
                     className: StringName("\(DemoProtractor.self)"),
                     hint: .multilineText,
                     hintStr: "",
                     usage: .default)
        ]

        classInfo.registerMethod(name: "_callable_templateRecognized",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: recognizedSignalProps,
                                 function: DemoProtractor._callable_templateRecognized)
    }
}
