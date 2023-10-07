//
//  DemoAshashatKeyboard.swift
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

import Ashashat
import SwiftGodot

@NativeHandleDiscarding
class DemoAshashatKeyboard: DemoBaseControl {
    @SceneTree(path: "Keyboard") var keyboard: AshashatKeyboardInterpreter?
    @SceneTree(path: "Label") var label: Label?
    @SceneTree(path: "TextField") var textField: Label?

    var textContents: String = ""

    required init() {
        DemoAshashatKeyboard.initClass
        super.init()
    }

    override func _ready() {
        super._ready()
        keyboard?.connect(signal: "key_pressed", callable: #methodName(keyPressed))
    }

    override func _unhandledInput(event: InputEvent?) {
        if Input.isActionPressed(action: "cancel") {
            LibDemoscene.logger.info("Received message to return to menu.")
            getTree()?.changeSceneToFile(path: "res://demos/demo_menu.tscn")
        }
    }

    @Callable
    func keyPressed(_ key: String) {
        guard let ashashatKey = AshashatKeyboardKey(keyCode: key) else {
            LibDemoscene.logger.error("Keystroke does not match an Ashashat key: \(key)")
            return
        }

        guard let textField else {
            LibDemoscene.logger.error("Text field is not initialized: \(textField)")
            return
        }

        switch ashashatKey {
        case .delete:
            textField.text = String(textField.text.dropLast())
            textContents = String(textContents.dropLast())
        case .return:
            if textContents.isEmpty, textField.text.isEmpty {
                LibDemoscene.logger.warning("Returned an empty value.")
                return
            }
            LibDemoscene.logger.info("Returned: \(textContents)")
            LibDemoscene.logger.debug("Font-rendered value: \(textField.text)")
        default:
            textField.text += ashashatKey.fontRenderedValue
            textContents += ashashatKey.keyValue
        }
    }
}

extension DemoAshashatKeyboard {
    static var initClass: Void = {
        let className = StringName(stringLiteral: "\(DemoAshashatKeyboard.self)")
        let classInfo = ClassInfo<DemoAshashatKeyboard>(name: className)

        let keyPressedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: StringName("key"),
                     className: StringName("\(DemoAshashatKeyboard.self)"),
                     hint: .multilineText,
                     hintStr: "",
                     usage: .default)
        ]

        classInfo.registerMethod(name: "_callable_keyPressed",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: keyPressedSignalProps,
                                 function: DemoAshashatKeyboard._callable_keyPressed)
    }()
}
