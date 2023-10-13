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
    public var expectedSolution: Int = 0
    public var numpadFieldPath: NodePath = ""

    @SceneTree(path: "Area2D") var detectionRing: Area2D?
    var numpadField: AshashatNumpadPuzzleField?

    var eligibleToLaunch = false

    public required init() {
        Self.initializeClass()
        super.init()
    }

    public override func _ready() {
        super._ready()

        numpadField = getNode(path: numpadFieldPath) as? AshashatNumpadPuzzleField
        if numpadField == nil {
            LibRollinsport.logger.error("Resulting node is nil! Tree: \(String(describing: getTree()))")
            return
        }

        // TODO: Errors should be handled here. (or ignored, when try? is adopted)
        if numpadField?.isConnected(signal: "editing_changed",
                                    callable: #methodName(numpadFieldEditingChanged)) != true {
            _ = numpadField?.connect(signal: "editing_changed",
                                     callable: #methodName(numpadFieldEditingChanged))
        }
        _ = detectionRing?.bodyEntered.connect { [weak self] body in
            self?.bodyEnteredRange(body: body)
        }
        _ = detectionRing?.bodyExited.connect { [weak self] _ in
            self?.eligibleToLaunch = false
            self?.numpadField?.clear()
            self?.numpadField?.hide()
        }
    }

    public override func _unhandledKeyInput(event: InputEvent?) {
        super._unhandledKeyInput(event: event)
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
            LibRollinsport.logger.debug(
                "Expected solution and input mismatch: \(value) is not equal to \(expectedSolution)")
            numpadField.flashIncorrect()
            return
        }
        numpadField.markCorrect()
        LibRollinsport.logger.debug("Solution and expectations match (\(value) == \(expectedSolution))")
    }

    func bodyEnteredRange(body: Node2D) {
        self.eligibleToLaunch = body.isClass("AnthroCharacterBody2D")
        LibRollinsport.logger.debug("Expected solution for current body is: \(expectedSolution)")

        // If the player has entered this area, and there's a touch screen, we can assume that they likely want to
        // interact with the puzzle.
        if DisplayServer.isTouchscreenAvailable(), eligibleToLaunch {
            self.numpadField?.show()
        }
    }
}

extension NumberPuzzleNode {
    public func getNumpadFieldPath(args: [Variant]) -> Variant? {
        Variant(numpadFieldPath)
    }

    public func getExpectedSolution(args: [Variant]) -> Variant? {
        Variant(expectedSolution)
    }

    public func setNumpadFieldPath(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "puzzleData", in: args) { arg in
            guard let realValue = NodePath(arg) else {
                LibRollinsport.logger.error("Retrieved value is nil (or type cast failed): \(arg)")
                return
            }
            numpadFieldPath = realValue
        }
    }

    public func setExpectedSolution(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "expectedSolution", in: args) { arg in
            expectedSolution = Int(arg) ?? 0
            LibRollinsport.logger.debug("Number node named '\(name)' set expected solution to: \(expectedSolution)")
        }
    }

    static func initializeClass() {
        let className = StringName(stringLiteral: "\(NumberPuzzleNode.self)")
        let classInfo = ClassInfo<NumberPuzzleNode>(name: className)

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

        classInfo.addPropertyGroup(name: "Puzzle Data", prefix: "puzzle_data")
        classInfo.registerInt(named: "expected_solution",
                              range: 0...31,
                              prefix: "puzzle_data",
                              getter: NumberPuzzleNode.getExpectedSolution,
                              setter: NumberPuzzleNode.setExpectedSolution)

        classInfo.addPropertyGroup(name: "World References", prefix: "world")
        classInfo.registerNodePath(named: "numpad_field",
                                   prefix: "world",
                                   getter: NumberPuzzleNode.getNumpadFieldPath,
                                   setter: NumberPuzzleNode.setNumpadFieldPath)
    }
}
