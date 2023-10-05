//
//  DemoAshashatNumpad.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/04/23.
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
class DemoAshashatNumpad: Control {
    @SceneTree(path: "Numpad")
    var numpad: AshashatNumpadInterpreter?

    @SceneTree(path: "TextField")
    var textField: Label?

    required init() {
        DemoAshashatNumpad.initClass
        super.init()
    }

    override func _ready() {
        super._ready()
        numpad?.connect(signal: "numpad_returned", callable: Callable(object: self, method: "numpadReturned"))
        LibDemoscene.logger.debug(
            "Registered connections: \(numpad?.getSignalConnectionList(signal: "numpad_returned"))")
    }

    override func _unhandledInput(event: InputEvent?) {
        if Input.isActionPressed(action: "cancel") {
            LibDemoscene.logger.info("Received message to return to menu.")
            getTree()?.changeSceneToFile(path: "res://demos/demo_menu.tscn")
        }
    }

    func numpadReturned(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "value", in: args) { value in
            guard let realValue = Int(value) else {
                LibDemoscene.logger.error("Expected numpad return type to contain a value, received nil instead.")
                return
            }
            LibDemoscene.logger.debug("Received value: \(realValue)")
            textField?.text = "Entered value: \(realValue)"
        }
    }

}

extension DemoAshashatNumpad {
    static let initClass: Void = {
        let className = StringName(stringLiteral: "\(DemoAshashatNumpad.self)")
        let classInfo = ClassInfo<DemoAshashatNumpad>(name: className)

        let returnedSignalProps = [
            PropInfo(propertyType: .int,
                     propertyName: StringName("value"),
                     className: StringName("\(DemoAshashatNumpad.self)"),
                     hint: .range,
                     hintStr: "0,31,1",
                     usage: .propertyUsageDefault)
        ]

        classInfo.registerMethod(name: "numpadReturned",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: returnedSignalProps,
                                 function: DemoAshashatNumpad.numpadReturned)
    }()
}
