//
//  WordPuzzleNode.swift
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

import Ashashat
import SwiftGodot

@NativeHandleDiscarding
public class WordPuzzleNode: Node2D {
    @Autovariant public var expectedSolution: String = ""
    @Autovariant public var textFieldPath: NodePath = ""

    @SceneTree(path: "Area2D") var detectionRing: Area2D?
    var textField: AshashatTextField?

    var eligibleToLaunch = false

    public required init() {
        Self.initializeClass()
        super.init()
    }

    public override func _ready() {
        super._ready()
        textField = getNode(path: textFieldPath) as? AshashatTextField
        if textField == nil {
            LibRollinsport.logger.error("Resulting node is nil! Tree: \(String(describing: getTree()))")
            return
        }

        do {
            try textField?.connectIfPresent(#methodName(textFieldEditingDidEnd), to: "editing_did_end")
            try textField?.connectIfPresent(#methodName(textFieldEditingChanged), to: "editing_changed")
        } catch {
            LibRollinsport.logger.error("Failed to connect 'editing_did_end' signal: \(error.localizedDescription)")
        }

        _ = detectionRing?.bodyEntered.connect { [weak self] body in
            self?.bodyEnteredRange(body: body)
        }

        _ = detectionRing?.bodyExited.connect { [weak self] body in
            self?.eligibleToLaunch = false
            self?.textField?.clear()
            self?.textField?.hide()
        }
    }

    override public func _unhandledInput(event: InputEvent?) {
        super._unhandledInput(event: event)
        if Input.isActionPressed(action: "interact"), eligibleToLaunch {
            textField?.show()
            return
        }
        if Input.isActionPressed(action: "cancel"), eligibleToLaunch {
            textField?.hide()
            return
        }
    }

    func bodyEnteredRange(body: Node2D) {
        eligibleToLaunch = body.isClass("AnthroCharacterBody2D")
        LibRollinsport.logger.debug("Expected solution for current body is: \(expectedSolution)")
        textField?.clear()

        // If the player has entered this area, and there's a touch screen, we can assume that they likely want to
        // interact with the puzzle.
        if DisplayServer.isTouchscreenAvailable(), eligibleToLaunch {
            textField?.show()
        }
    }

    @Callable func textFieldEditingChanged(_: String) {
        textField?.animator?.stop(keepState: false)
    }

    @Callable func textFieldEditingDidEnd(_ value: String) {
        guard eligibleToLaunch, let textField else { return }
        if value != expectedSolution {
            LibRollinsport.logger.debug("Expected solution and input mismatch: (\(value) != \(expectedSolution))")
            textField.flashIncorrect()
            return
        }
        LibRollinsport.logger.debug("Solution and expectations match (\(value) == \(expectedSolution)).")
        textField.markCorrect()
    }
}

extension WordPuzzleNode {
    static func initializeClass() {
        let className = StringName("\(WordPuzzleNode.self)")
        let classInfo = ClassInfo<WordPuzzleNode>(name: className)

        let editingChangedProps = [
            PropInfo(propertyType: .string,
                     propertyName: "value",
                     className: StringName("\(NumberPuzzleNode.self)"),
                     hint: .typeString,
                     hintStr: "",
                     usage: .default)
        ]

        classInfo.registerMethod(name: "_callable_textFieldEditingDidEnd",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: editingChangedProps,
                                 function: WordPuzzleNode._callable_textFieldEditingDidEnd)
        classInfo.registerMethod(name: "_callable_textFieldEditingChanged",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: editingChangedProps,
                                 function: WordPuzzleNode._callable_textFieldEditingChanged)

        classInfo.addPropertyGroup(name: "Puzzle Data", prefix: "puzzle_data")
        classInfo.regsiterTextView(named: "expected_solution",
                                    prefix: "puzzle_data",
                                    getter: WordPuzzleNode._getVariant_expectedSolution,
                                    setter: WordPuzzleNode._setVariant_expectedSolution)

        classInfo.addPropertyGroup(name: "World References", prefix: "world")
        classInfo.registerNodePath(named: "text_field",
                                   prefix: "world",
                                   getter: WordPuzzleNode._getVariant_textFieldPath,
                                   setter: WordPuzzleNode._setVariant_textFieldPath)
    }
}
