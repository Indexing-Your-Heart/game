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

extension AnthroCharacterBody2D {
    static func initializeClass() {
        let classInfo = ClassInfo<AnthroCharacterBody2D>(name: "AnthroCharacterBody2D")

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

        classInfo.registerEnum(named: "character",
                               for: Character.self,
                               prefix: "player",
                               getter: AnthroCharacterBody2D.getCharacter,
                               setter: AnthroCharacterBody2D.setCharacter)

        classInfo.addPropertyGroup(name: "Movement", prefix: "movement_")
        classInfo.registerInt(named: "acceleration",
                              range: 1 ... 1000,
                              stride: 5,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D._getVariant_acceleration,
                              setter: AnthroCharacterBody2D._setVariant_acceleration)
        classInfo.registerInt(named: "speed",
                              range: 1 ... 1000,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D._getVariant_speed,
                              setter: AnthroCharacterBody2D._setVariant_speed)
        classInfo.registerInt(named: "friction",
                              range: 1 ... 1000,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D._getVariant_friction,
                              setter: AnthroCharacterBody2D._setVariant_friction)
    }

    func getCharacter(args _: [Variant]) -> Variant? {
        Variant(character.rawValue)
    }

    func setCharacter(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "character", in: args) { arg in
            character = Character(rawValue: Int(arg) ?? 0) ?? .chelsea
            changeSprites()
        }
    }
}
