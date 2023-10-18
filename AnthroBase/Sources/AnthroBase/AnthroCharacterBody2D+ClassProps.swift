//
//  AnthroCharacterBody2D+ClassProps.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/27/23.
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

extension AnthroCharacterBody2D: GodotInspectable {
    public typealias T = AnthroCharacterBody2D
    public static var inspector: Inspector<T> {
        Inspector {
            Picker("character",
                   for: Character.self,
                   property: #autoProperty(object: AnthroCharacterBody2D.self, "character"))
            Group<AnthroCharacterBody2D>("Movement", prefix: "movement_") {
                NumberRange("speed",
                            limit: 1 ... 1000,
                            stride: 5,
                            property: #autoProperty(object: AnthroCharacterBody2D.self, "speed"))
                NumberRange("acceleration",
                            limit: 1 ... 1000,
                            property: #autoProperty(object: AnthroCharacterBody2D.self, "acceleration"))
                NumberRange("friction",
                            limit: 1 ... 1000,
                            property: #autoProperty(object: AnthroCharacterBody2D.self, "friction"))
            }
        }
    }
}

extension AnthroCharacterBody2D {
    static func initializeClass() {
        let classInfo = ClassInfo<AnthroCharacterBody2D>(name: "AnthroCharacterBody2D")
        classInfo.registerInspector()

        let moveTowardProps = [
            PropInfo(propertyType: .vector2,
                     propertyName: "destination",
                     className: StringName("\(AnthroCharacterBody2D.self)"),
                     hint: .expression,
                     hintStr: "",
                     usage: .default)
        ]
        classInfo.registerMethod(name: "move_toward",
                                 flags: .default,
                                 returnValue: nil,
                                 arguments: moveTowardProps,
                                 function: AnthroCharacterBody2D._callable_moveToward)
    }
}
