//
//  AshashatNumpadPuzzleField.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/09/23.
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

@NativeHandleDiscarding
public class AshashatNumpadPuzzleField: Control, AshashatValidatedField {
    public typealias InputMechanism = AshashatNumpadInterpreter
    public typealias InputValue = Int

    @SceneTree(path: "VStack/NumberLabel") public var label: Label?
    @SceneTree(path: "VStack/HStack/Numpad") public var inputMechanism: AshashatNumpadInterpreter?
    @SceneTree(path: "Animator") public var animator: AnimationPlayer?

    public var currentValue: Int = 0

    public required init() {
        Self.initializeClass()
        super.init()
    }

    override public func _ready() {
        _ = inputMechanism?.connect(signal: AshashatNumpadInterpreter.returnedSignalName,
                                    callable: #methodName(inputReturned))
    }

    @Callable public func clear() {
        currentValue = 0
        label?.text = "???"
        animator?.stop()
        inputMechanism?.clear()
        label?.modulate = .white
        LibAshashat.logger.debug("Value reset to: \(currentValue)")
    }

    @Callable public func flashIncorrect() {
        runAnimation(named: .incorrect)
    }

    @Callable public func markCorrect() {
        runAnimation(named: .correct)
    }

    @Callable public func inputReturned(value: Int) {
        label?.text = String(value)
        currentValue = value
        sendActions(for: .editingChanged)
    }
}

extension AshashatNumpadPuzzleField {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(AshashatNumpadPuzzleField.self)")
        let classInfo = ClassInfo<AshashatNumpadPuzzleField>(name: className)
        Self.registerField(using: classInfo,
                           value: PropInfo(propertyType: .int,
                                           propertyName: StringName("value"),
                                           className: StringName("\(AshashatNumpadPuzzleField.self)"),
                                           hint: .range,
                                           hintStr: "0,31,1",
                                           usage: .default))
    }
}
