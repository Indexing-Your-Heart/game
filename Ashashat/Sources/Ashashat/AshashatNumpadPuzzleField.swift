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
public class AshashatNumpadPuzzleField: Control {
    public enum AnimationName: String {
        case correct
        case incorrect
        case reset = "RESET"

        var stringName: StringName {
            StringName(rawValue)
        }
    }

    public static var editingChangedSignalName = StringName("editing_changed")
    @SceneTree(path: "VStack/NumberLabel") var numberLabel: Label?
    @SceneTree(path: "VStack/HStack/Numpad") var numpad: AshashatNumpadInterpreter?
    @SceneTree(path: "Animator") var animator: AnimationPlayer?

    public var currentValue: Int = 0

    public required init() {
        Self.initializeClass()
        super.init()
    }

    override public func _ready() {
        _ = numpad?.connect(signal: AshashatNumpadInterpreter.returnedSignalName,
                            callable: #methodName(numpadReturned))
    }

    @Callable public func clear() {
        currentValue = 0
        numberLabel?.text = "???"
        animator?.stop()
        numpad?.clear()
        numberLabel?.modulate = .white
        LibAshashat.logger.debug("Value reset to: \(currentValue)")
    }

    @Callable public func flashIncorrect() {
        runAnimation(named: .incorrect)
    }

    @Callable public func markCorrect() {
        runAnimation(named: .correct)
    }

    @Callable func numpadReturned(_ value: Int) {
        numberLabel?.text = String(value)
        currentValue = value
        emitSignal(Self.editingChangedSignalName, currentValue.toVariant())
    }

    func runAnimation(named animationName: AnimationName) {
        guard let animator else {
            LibAshashat.logger.error("Cannot call an animation on a nil player.")
            return
        }
        if animator.isPlaying() {
            animator.stop(keepState: false)
        }
        animator.play(name: animationName.stringName)
    }
}

extension AshashatNumpadPuzzleField {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(AshashatNumpadPuzzleField.self)")
        let classInfo = ClassInfo<AshashatNumpadPuzzleField>(name: className)

        let returnedSignalProps = [
            PropInfo(propertyType: .int,
                     propertyName: StringName("value"),
                     className: StringName("\(AshashatNumpadPuzzleField.self)"),
                     hint: .range,
                     hintStr: "0,31,1",
                     usage: .default)
        ]

        classInfo.registerSignal(name: Self.editingChangedSignalName, arguments: returnedSignalProps)
        classInfo.registerMethod(name: "_callable_numpadReturned",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: returnedSignalProps,
                                 function: AshashatNumpadPuzzleField._callable_numpadReturned)
        classInfo.registerMethod(name: "flash_incorrect",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: AshashatNumpadPuzzleField._callable_flashIncorrect)
        classInfo.registerMethod(name: "clear",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: AshashatNumpadPuzzleField._callable_clear)
        classInfo.registerMethod(name: "mark_correct",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: AshashatNumpadPuzzleField._callable_markCorrect)
    }
}
