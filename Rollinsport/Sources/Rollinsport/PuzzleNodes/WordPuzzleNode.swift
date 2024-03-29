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
    static var solvedSignalName: StringName = "puzzle_solved"
    @Autovariant public var expectedSolution: String = ""
    @Autovariant public var textFieldPath: NodePath = ""
    @Autovariant public var puzzleId: String = ""

    @SceneTree(path: "Area2D") var detectionRing: Area2D?
    var textField: AshashatTextField?

    var eligibleToLaunch = false

    public required init() {
        Self.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()
        textField = getNode(path: textFieldPath) as? AshashatTextField
        if textField == nil {
            LibRollinsport.logger.error("Resulting node is nil! Tree: \(String(describing: getTree()))")
            return
        }

        do {
            try RollinsportMessageBus.shared.registerSubscriber(#methodName(solutionFound), to: .foundSolution(id: ""))
        } catch {
            LibRollinsport.logger.error("Failed to subscribe to message bus: \(error.localizedDescription)")
        }

        do {
            try textField?.addTarget(for: .editingChanged, #methodName(textFieldEditingChanged))
            try textField?.addTarget(for: .editingDidEnd, #methodName(textFieldEditingDidEnd))
        } catch {
            LibRollinsport.logger.error("Failed to connect signal: \(error.localizedDescription)")
        }

        _ = try? detectionRing?.bodyEntered.connect { [weak self] body in
            self?.bodyEnteredRange(body: body)
        }

        _ = try? detectionRing?.bodyExited.connect { [weak self] _ in
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

        do {
            try RollinsportMessageBus.shared.notify(.requestForSolve(id: puzzleId))
        } catch {
            LibRollinsport.logger.error("Failed to send message: \(error.localizedDescription)")
        }

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
        do {
            try RollinsportMessageBus.shared.notify(.puzzleSolved(id: puzzleId))
        } catch {
            LibRollinsport.logger.error("Failed to notify message bus: \(error.localizedDescription)")
        }
        textField.markCorrect()
    }

    @Callable func solutionFound(id: String) {
        guard id == puzzleId else { return }
        textField?.prefill(expectedSolution)
        textField?.markCorrect()
    }
}

extension WordPuzzleNode: GodotInspectable {
    public static var inspector: Inspector<WordPuzzleNode> {
        Inspector {
            Group<WordPuzzleNode>("Puzzle Data", prefix: "puzzle_data") {
                Text(name: "expected_solution",
                     multiline: true,
                     property: #autoProperty(object: WordPuzzleNode.self, "expectedSolution"))
                Text(name: "puzzle_id", property: #autoProperty(object: WordPuzzleNode.self, "puzzleId"))
            }
            Group<WordPuzzleNode>("World References", prefix: "world") {
                NodePathPicker("text_field", property: #autoProperty(object: WordPuzzleNode.self, "textFieldPath"))
            }
        }
    }
}

extension WordPuzzleNode {
    static func initializeClass() {
        let className = StringName("\(WordPuzzleNode.self)")
        let classInfo = ClassInfo<WordPuzzleNode>(name: className)
        classInfo.registerInspector()

        let editingChangedProps = [
            PropInfo(propertyType: .string,
                     propertyName: "value",
                     className: className,
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
        classInfo.registerMethod(name: "_callable_solutionFound",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: editingChangedProps,
                                 function: WordPuzzleNode._callable_solutionFound)
    }
}
