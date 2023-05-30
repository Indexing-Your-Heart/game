//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/27/23.
//

import Foundation
import SwiftGodot

extension AnthroCharacterBody2D {
    static var initClass: Void = {
        let classInfo = ClassInfo<AnthroCharacterBody2D>(name: "AnthroCharacterBody2D")
        classInfo.registerEnum(named: "character",
                               for: Character.self,
                               prefix: "player",
                               getter: AnthroCharacterBody2D.getCharacter,
                               setter: AnthroCharacterBody2D.setCharacter)

        classInfo.addPropertyGroup(name: "Movement", prefix: "movement_")
        classInfo.registerInt(named: "acceleration",
                              range: 1...1000,
                              stride: 5,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D.getAcceleration,
                              setter: AnthroCharacterBody2D.setAcceleration)
        classInfo.registerInt(named: "speed",
                              range: 1...1000,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D.getSpeed,
                              setter: AnthroCharacterBody2D.setSpeed)
        classInfo.registerInt(named: "friction",
                              range: 1...1000,
                              prefix: "movement",
                              getter: AnthroCharacterBody2D.getFriction,
                              setter: AnthroCharacterBody2D.setFriction)
    }()

    public func getAcceleration(args _: [Variant]) -> Variant? {
        Variant(Int(acceleration))
    }

    func getCharacter(args _: [Variant]) -> Variant? {
        Variant(character.rawValue)
    }

    func getFriction(args _: [Variant]) -> Variant? {
        Variant(Int(friction))
    }

    func getSpeed(args _: [Variant]) -> Variant? {
        Variant(Int(speed))
    }

    func setAcceleration(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "acceleration", in: args) { arg in
            acceleration = Float(Int(arg) ?? 250)
        }
    }

    func setCharacter(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "character", in: args) { arg in
            character = Character(rawValue: Int(arg) ?? 0) ?? .chelsea
        }
    }

    func setFriction(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "friction", in: args) { arg in
            friction = Double(Int(arg) ?? 100)
        }
    }

    func setSpeed(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "speed", in: args) { arg in
            speed = Double(Int(arg) ?? 100)
        }
    }
}
