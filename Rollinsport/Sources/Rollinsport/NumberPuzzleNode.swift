//
//  NumberPuzzleNode.swift
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

import Ashashat
import SwiftGodot

@NativeHandleDiscarding
public class NumberPuzzleNode: Node2D {
    @Autovariant public var expectedSolution: Int = 0
    @Autovariant public var numpadFieldPath: NodePath = ""

    @SceneTree(path: "Area2D") var detectionRing: Area2D?
    var numpadField: AshashatNumpadPuzzleField?

    var eligibleToLaunch = false

    public required init() {
        Self.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()

        numpadField = getNode(path: numpadFieldPath) as? AshashatNumpadPuzzleField
        if numpadField == nil {
            LibRollinsport.logger.error("Resulting node is nil! Tree: \(String(describing: getTree()))")
            return
        }

        do {
            try numpadField?.addTarget(for: .editingChanged, #methodName(numpadFieldEditingChanged))
        } catch {
            LibRollinsport.logger.error("Failed to connect 'editing_changed' signal: \(error.localizedDescription)")
        }

        _ = try? detectionRing?.bodyEntered.connect { [weak self] body in
            self?.bodyEnteredRange(body: body)
        }
        _ = try? detectionRing?.bodyExited.connect { [weak self] _ in
            self?.eligibleToLaunch = false
            self?.numpadField?.clear()
            self?.numpadField?.hide()
        }
    }

    override public func _unhandledInput(event: InputEvent?) {
        super._unhandledInput(event: event)
        if Input.isActionPressed(action: "interact"), eligibleToLaunch {
            numpadField?.show()
            return
        }
        if Input.isActionPressed(action: "cancel"), eligibleToLaunch {
            numpadField?.hide()
            return
        }
    }

    @Callable func numpadFieldEditingChanged(_ value: Int) {
        guard eligibleToLaunch, let numpadField else { return }
        if value != expectedSolution {
            LibRollinsport.logger
                .debug("Expected solution and input mismatch: \(value) is not equal to \(expectedSolution)")
            numpadField.flashIncorrect()
            return
        }
        numpadField.markCorrect()
        LibRollinsport.logger.debug("Solution and expectations match (\(value) == \(expectedSolution))")
    }

    func bodyEnteredRange(body: Node2D) {
        eligibleToLaunch = body.isClass("AnthroCharacterBody2D")
        LibRollinsport.logger.debug("Expected solution for current body is: \(expectedSolution)")

        // If the player has entered this area, and there's a touch screen, we can assume that they likely want to
        // interact with the puzzle.
        if DisplayServer.isTouchscreenAvailable(), eligibleToLaunch {
            numpadField?.show()
        }
    }
}

extension NumberPuzzleNode: GodotInspectable {
    public static var inspector: Inspector<NumberPuzzleNode> {
        Inspector {
            Group<NumberPuzzleNode>("Puzzle Data", prefix: "puzzle_data") {
                NumberRange("expected_solution",
                            limit: 0 ... 31,
                            property: #autoProperty(object: NumberPuzzleNode.self, "expectedSolution"))
            }
            Group<NumberPuzzleNode>("World References", prefix: "world") {
                NodePathPicker("numpad_field",
                               property: #autoProperty(object: NumberPuzzleNode.self, "numpadFieldPath"))
            }
        }
    }
}

extension NumberPuzzleNode {
    static func initializeClass() {
        let className = StringName(stringLiteral: "\(NumberPuzzleNode.self)")
        let classInfo = ClassInfo<NumberPuzzleNode>(name: className)
        classInfo.registerInspector()

        let editingChangedProps = [
            PropInfo(propertyType: .int,
                     propertyName: StringName("value"),
                     className: StringName("\(NumberPuzzleNode.self)"),
                     hint: .range,
                     hintStr: "0,31,1",
                     usage: .default)
        ]

        classInfo.registerMethod(name: "_callable_numpadFieldEditingChanged",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: editingChangedProps,
                                 function: NumberPuzzleNode._callable_numpadFieldEditingChanged)
    }
}
