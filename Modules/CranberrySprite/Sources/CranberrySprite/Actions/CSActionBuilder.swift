//
//  CSActionBuilder.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

import SpriteKit

/// A result builder capable of building an SKAction sequence.
@resultBuilder
public enum CSActionBuilder {
    public static func buildArray(_ components: [[SKAction]]) -> [SKAction] {
        components.flatMap { $0 }
    }

    public static func buildBlock(_ components: [SKAction]...) -> [SKAction] {
        components.flatMap { $0 }
    }

    public static func buildEither(first component: [SKAction]) -> [SKAction] {
        component
    }

    public static func buildEither(second component: [SKAction]) -> [SKAction] {
        component
    }

    public static func buildExpression(_ expression: SKAction) -> [SKAction] {
        [expression]
    }

    public static func buildExpression(_ expression: [SKAction]) -> [SKAction] {
        expression
    }
}
