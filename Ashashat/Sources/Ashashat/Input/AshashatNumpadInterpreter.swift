//
//  AshashatNumpadInterpreter.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/23/23.
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

/// A virtual number pad represented in the [ʔaʃaʃat] language.
///
/// Whenever the return key is pressed, the `numpad_returned` signal is emitted with the final value as a number
/// between 0 and 31.
@NativeHandleDiscarding
public class AshashatNumpadInterpreter: Control {
    /// The signal name for the `numpad_returned` signal.
    public static var returnedSignalName: StringName = "numpad_returned"

    @SceneTree(path: "key1") private var key1: Button?
    @SceneTree(path: "key2") private var key2: Button?
    @SceneTree(path: "key4") private var key4: Button?
    @SceneTree(path: "key8") private var key8: Button?
    @SceneTree(path: "key16") private var key16: Button?

    @SceneTree(path: "keyReturn") private var keyReturn: Button?

    private var internalValue: Int = 0
    private lazy var mapping: [Int: Button?] = [
        1: self.key1,
        2: self.key2,
        4: self.key4,
        8: self.key8,
        16: self.key16
    ]

    public required init() {
        AshashatNumpadInterpreter.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()
        for (number, key) in mapping {
            key?.pressed.connect { [weak self] in
                guard let key, let self else { return }

                // If already pressed, remove the number from the count (i.e., turn off that bit).
                internalValue += key.buttonPressed ? number : number * -1
            }
        }
        keyReturn?.pressed.connect { [self] in
            emitSignal(Self.returnedSignalName, internalValue.toVariant())
        }
    }

    @Callable
    public func clear() {
        internalValue = 0
        for (_, key) in mapping {
            key?.buttonPressed = false
        }
    }
}

extension AshashatNumpadInterpreter {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(AshashatNumpadInterpreter.self)")
        let classInfo = ClassInfo<AshashatNumpadInterpreter>(name: className)

        // MARK: Signal Registration

        let returnedSignalProps = [
            PropInfo(propertyType: .int,
                     propertyName: StringName("value"),
                     className: StringName("\(AshashatNumpadInterpreter.self)"),
                     hint: .range,
                     hintStr: "0,31,1",
                     usage: .default)
        ]
        classInfo.registerSignal(name: returnedSignalName, arguments: returnedSignalProps)
        classInfo.registerMethod(name: "clear",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: AshashatNumpadInterpreter._callable_clear)
    }
}
