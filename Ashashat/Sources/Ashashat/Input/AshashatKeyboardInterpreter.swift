//
//  AshashatKeyboardInterpreter.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/17/23.
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

#if canImport(AudioToolbox)
import AudioToolbox
#endif

/// A virtual keyboard that sends characters in the [ʔaʃaʃat] language.
///
/// Whenever a key is pressed, the `key_pressed` signal is emitted, allowing responders to listen for key events.
@NativeHandleDiscarding
public class AshashatKeyboardInterpreter: Control {
    /// The signal name for the `key_pressed` signal.
    public static var keyPressedSignalName: StringName = "key_pressed"

    @SceneTree(path: "keyA") private var keyA: Button?
    @SceneTree(path: "keyE") private var keyE: Button?
    @SceneTree(path: "keyI") private var keyI: Button?
    @SceneTree(path: "keyU") private var keyU: Button?

    @SceneTree(path: "keyP") private var keyP: Button?
    @SceneTree(path: "keyB") private var keyB: Button?
    @SceneTree(path: "keyT") private var keyT: Button?
    @SceneTree(path: "keyK") private var keyK: Button?
    @SceneTree(path: "keyN") private var keyN: Button?
    @SceneTree(path: "keyL") private var keyL: Button?
    @SceneTree(path: "keyS") private var keyS: Button?

    @SceneTree(path: "keySh") private var keySh: Button?
    @SceneTree(path: "keyGlottal") private var keyGlottal: Button?
    @SceneTree(path: "keyEjectiveK") private var keyEjectiveK: Button?

    @SceneTree(path: "keyReturn") private var keyReturn: Button?
    @SceneTree(path: "keyDelete") private var keyDelete: Button?
    @SceneTree(path: "keyRepeat") private var keyRepeat: Button?
    @SceneTree(path: "keyDuplicant") private var keyDuplicant: Button?

    private lazy var keyMapping: [AshashatKeyboardKey: Button?] = [
        .a: self.keyA,
        .i: self.keyI,
        .e: self.keyE,
        .u: self.keyU,
        .p: self.keyP,
        .b: self.keyB,
        .t: self.keyT,
        .k: self.keyK,
        .l: self.keyL,
        .s: self.keyS,
        .n: self.keyN,
        .sh: self.keySh,
        .glottal: self.keyGlottal,
        .ejectiveK: self.keyEjectiveK,
        .return: self.keyReturn,
        .delete: self.keyDelete,
        .repeater: self.keyRepeat,
        .duplicant: self.keyDuplicant
    ]

    required init() {
        AshashatKeyboardInterpreter.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()
        for (ashashatKey, keyButton) in keyMapping {
            do {
                try keyButton?.pressed.connect { [self] in pressKey(ashashatKey) }
            } catch {
                LibAshashat.logger.error("Failed to connect press for key '\(ashashatKey)': \(error)")
            }
        }
    }

    private func pressKey(_ key: AshashatKeyboardKey) {
        #if canImport(AudioToolbox)
        LibAshashat.logger.debug("Playing keyboard sound with ID: \(key.keySoundId)")
        AudioServicesPlaySystemSound(key.keySoundId)
        #endif
        try? emitSignal(AshashatKeyboardInterpreter.keyPressedSignalName, Variant(stringLiteral: key.keyCode))
    }
}

extension AshashatKeyboardInterpreter {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(AshashatKeyboardInterpreter.self)")
        let classInfo = ClassInfo<AshashatKeyboardInterpreter>(name: className)

        // MARK: Signal Registration

        let keyPressedSignalProps = [
            PropInfo(propertyType: .string,
                     propertyName: StringName("key"),
                     className: StringName("\(AshashatKeyboardInterpreter.self)"),
                     hint: .typeString,
                     hintStr: "The key that was pressed.",
                     usage: .default)
        ]
        classInfo.registerSignal(name: keyPressedSignalName, arguments: keyPressedSignalProps)
    }
}
