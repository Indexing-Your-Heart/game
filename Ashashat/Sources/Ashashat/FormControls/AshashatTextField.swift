//
//  AshashatTextField.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/14/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import AshashatKit
import SwiftGodot

@NativeHandleDiscarding
public class AshashatTextField: Control, AshashatValidatedField {
    public typealias InputMechanism = AshashatKeyboardInterpreter
    public typealias InputValue = String

    public var currentValue: String = ""
    @SceneTree(path: "VStack/PanelContainer/TextLabel") public var label: Label?
    @SceneTree(path: "VStack/HStack/Keyboard") public var inputMechanism: AshashatKeyboardInterpreter?
    @SceneTree(path: "Animator") public var animator: AnimationPlayer?

    public required init() {
        Self.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()
        try? inputMechanism?.connectIfPresent(#methodName(keyPressed), to: "key_pressed")
    }

    @Callable public func clear() {
        currentValue = ""
        label?.text = ""
        animator?.stop(keepState: false)
        label?.modulate = .white
        runAnimation(named: .reset)
    }

    @Callable public func flashIncorrect() {
        runAnimation(named: .incorrect)
    }

    @Callable public func markCorrect() {
        runAnimation(named: .correct)
    }

    @Callable func keyPressed(_ key: String) {
        guard let ashashatKey = AshashatKeyboardKey(keyCode: key) else {
            LibAshashat.logger.error("Cannot parse unknown key: \(key)")
            return
        }

        guard let textField = label else {
            LibAshashat.logger.error("Label is undefined.")
            return
        }

        switch ashashatKey {
        case .delete:
            textField.text = String(textField.text.dropLast())
            currentValue = String(currentValue.dropLast())
            sendActions(for: .editingChanged)
        case .return:
            sendActions(for: .editingDidEnd)
        default:
            textField.text += ashashatKey.fontRenderedValue
            currentValue += ashashatKey.keyValue
            sendActions(for: .editingChanged)
        }
    }

    @Callable public func inputReturned(value _: String) {}
}

extension AshashatTextField {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(AshashatTextField.self)")
        let classInfo = ClassInfo<AshashatTextField>(name: className)

        Self.registerField(using: classInfo,
                           value: PropInfo(propertyType: .string,
                                           propertyName: StringName("value"),
                                           className: StringName("\(AshashatTextField.self)"),
                                           hint: .typeString,
                                           hintStr: "",
                                           usage: .default))
        classInfo.registerMethod(name: "_callable_keyPressed",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [
                                     PropInfo(propertyType: .string,
                                              propertyName: StringName("key"),
                                              className: StringName("\(AshashatTextField.self)"),
                                              hint: .typeString,
                                              hintStr: "",
                                              usage: .default)
                                 ],
                                 function: AshashatTextField._callable_keyPressed)
    }
}
