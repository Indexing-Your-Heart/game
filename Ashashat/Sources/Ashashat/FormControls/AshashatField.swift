//
//  AshashatField.swift
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

import SwiftGodot

/// A protocol that uses an input mechanism to send data in the [ʔaʃaʃat] conlang and handles validation of input.
public typealias AshashatValidatedField = AshashatField & AshashatFieldValidating

/// A protocol that uses an input mechanism to send data in the [ʔaʃaʃat] conlang.
public protocol AshashatField: Node, AshashatFieldRegistering {
    /// The mechanism that will send input.
    associatedtype InputMechanism

    /// The type of the input value.
    associatedtype InputValue: GodotVariant

    /// The current value stored.
    var currentValue: InputValue { get set }

    /// A label that renders the current value.
    var label: Label? { get }

    /// The current input mechanism that updates the current value.
    var inputMechanism: InputMechanism? { get }

    /// Clears the current input.
    func clear()

    /// Processed the current returned value.
    func inputReturned(value: InputValue)
}

/// A protocol that defines registrations methods an input field can adopt to register to Godot.
public protocol AshashatFieldRegistering {
    /// A wrapper for the ``AshashatField/clear()`` method suitable for Godot registration.
    ///
    /// - Note: It is not recommended to call this method directly.
    func _callable_clear(args: [Variant]) -> Variant?

    /// A wrapper for the ``AshashatField/inputReturned(value:)`` method suitable for Godot registration.
    ///
    /// - Note: It is not recommended to call this method directly.
    func _callable_inputReturned(args: [Variant]) -> Variant?
}

/// A protocol that defines validation mechanisms for an [ʔaʃaʃat] input field.
public protocol AshashatFieldValidating: Node, AshashatFieldValidationRegistering {
    /// An animation player used to play validation animations.
    var animator: AnimationPlayer? { get }

    /// Plays an animation indicating the input is invalid.
    func flashIncorrect()

    /// Plays an animation indicating the input is valid.
    func markCorrect()
}

/// A protocol that defines registration methods in an input field can adopt to register to Godot for validation.
public protocol AshashatFieldValidationRegistering {
    /// A wrapper for the ``AshashatFieldValidating/flashIncorrect()`` method suitable for Godot registration.
    ///
    /// - Note: It is not recommended to call this method directly.
    func _callable_flashIncorrect(args: [Variant]) -> Variant?

    /// A wrapper for the ``AshashatFieldValidating/markCorrect()`` method suitable for Godot registration.
    ///
    /// - Note: It is not recommended to call this method directly.
    func _callable_markCorrect(args: [Variant]) -> Variant?
}

public extension AshashatField {
    /// Emits a speficied signal to an input field's listeners.
    /// - Parameter signal: The signal to emit.
    func sendActions(for signal: AshashatFieldSignal) {
        if signal.requiresCurrentValue {
            self.emitSignal(signal.stringName, currentValue.toVariant())
            return
        }
        self.emitSignal(signal.stringName)
    }

    /// Registers the clear method to Godot.
    /// - Parameter classInfo: The class information object that the method will be registered to.
    static func registerClear<T: AshashatFieldRegistering>(using classInfo: ClassInfo<T>) {
        classInfo.registerMethod(name: "clear",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: T._callable_clear)
    }

    /// Registers the inputReturned method to Godot.
    /// - Parameter classInfo: The class information object that the method will be registered to.
    /// - Parameter value: The property information describing the input value.
    static func registerInputReturned<T: AshashatFieldRegistering>(using classInfo: ClassInfo<T>, value: PropInfo) {
        classInfo.registerMethod(name: "_callable_inputReturned",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [value],
                                 function: T._callable_inputReturned)
    }

    /// Registers the editing signals to Godot.
    /// - Parameter classInfo: The class information object to register the signals to.
    /// - Parameter value: The property information describing the input value.
    static func registerEditingSignals<T: AshashatFieldRegistering>(using classInfo: ClassInfo<T>, value: PropInfo) {
        for signal in AshashatFieldSignal.allCases {
            classInfo.registerSignal(name: signal.stringName, arguments: signal.requiresCurrentValue ? [value]: [])
        }
    }

    /// Registers all methods and signals of the input field to Godot.
    /// - Parameter classInfo: The class information object to register the methods and signals to.
    /// - Parameter value: The property information describing the input value.
    static func registerField<T>(
        using classInfo: ClassInfo<T>, value: PropInfo
    ) where T: AshashatFieldRegistering & AshashatFieldValidationRegistering {
        Self.registerClear(using: classInfo)
        Self.registerEditingSignals(using: classInfo, value: value)
        Self.registerInputReturned(using: classInfo, value: value)
    }
}

public extension AshashatField where Self: AshashatFieldValidating {
    /// Runs an animation in the animation player, stopping the current animation if one is present.
    /// - Parameter name: The animation to play in the player.
    func runAnimation(named name: AshashatFieldAnimationName) {
        guard let animator else { return }
        animator.stop(keepState: false)
        animator.play(name: name.stringName)
    }
    
    /// Registers the `flash_incorrect` and `mark_correct` methods to Godot.
    /// - Parameter classInfo: The class information object that the method will be registered to.
    static func registerValidationMethods<T: AshashatFieldValidationRegistering>(using classInfo: ClassInfo<T>) {
        classInfo.registerMethod(name: "flash_incorrect",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: T._callable_flashIncorrect)
        classInfo.registerMethod(name: "mark_correct",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: [],
                                 function: T._callable_markCorrect)
    }

    /// Registers all methods and signals of the input field to Godot.
    /// - Parameter classInfo: The class information object to register the methods and signals to.
    /// - Parameter value: The property information describing the input value.
    static func registerField<T>(
        using classInfo: ClassInfo<T>, value: PropInfo
    ) where T: AshashatFieldRegistering & AshashatFieldValidationRegistering {
        Self.registerClear(using: classInfo)
        Self.registerValidationMethods(using: classInfo)
        Self.registerEditingSignals(using: classInfo, value: value)
        Self.registerInputReturned(using: classInfo, value: value)
    }
}

/// An enumeration for the minimum animations needed for an [ʔaʃaʃat] input field.
public enum AshashatFieldAnimationName: String {
    /// An animation that plays when the input is valid.
    case correct

    /// An animation that plays when the input is invalid.
    case incorrect

    /// The reset animation.
    case reset = "RESET"

    /// The string name that represents this animation.
    public var stringName: StringName {
        StringName(self.rawValue)
    }
}

/// An enumeration for the different signals an [ʔaʃaʃat] input field can emit.
public enum AshashatFieldSignal: String, CaseIterable {
    /// A signal that emits when editing begins.
    case editingDidBegin = "editing_did_begin"

    /// A signal that emits when editing has changed.
    ///
    /// This signal will also provide the current value as an argument.
    case editingChanged = "editing_changed"

    /// A signal that emits when editing has ended.
    ///
    /// This signal will also provide the current value as an argument.
    case editingDidEnd = "editing_did_end"

    /// The string name that represents the signal.
    public var stringName: StringName {
        StringName(self.rawValue)
    }

    /// Whether the signal references the current input value.
    public var requiresCurrentValue: Bool {
        switch self {
        case .editingChanged, .editingDidEnd:
            true
        default:
            false
        }
    }
}
