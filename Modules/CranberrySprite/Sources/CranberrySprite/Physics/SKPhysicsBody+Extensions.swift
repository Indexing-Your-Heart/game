//
//  SKPhysicsBody+Extensions.swift
//  
//
//  Created by Marquis Kurt on 11/22/22.
//

import SpriteKit

/// A protocol that acts as a factory for generating immovable object physics bodies.
public protocol CSPhysicsImmovableCreator {
    /// The physics body type that will be manipulated.
    associatedtype PhysicsBody

    /// Creates a physics body that acts as an immovable object.
    /// - Parameter cgSize: The rectangular size of the object.
    static func immovableObject(sized cgSize: CGSize) -> PhysicsBody

    /// Creates a physics body that acts as an immovable object.
    /// - Parameter texture: The SKTexture of a node that the body will take shape of.
    /// - Parameter cgSize: The size of the node.
    static func immovableObject(using texture: SKTexture, of size: CGSize) -> PhysicsBody
}

extension SKPhysicsBody: CSPhysicsImmovableCreator {
    public typealias PhysicsBody = SKPhysicsBody

    public static func immovableObject(sized cgSize: CGSize) -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: cgSize)
        body.setImmovableProperties()
        return body
    }

    public static func immovableObject(using texture: SKTexture, of size: CGSize) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, size: size)
        body.setImmovableProperties()
        return body
    }

    private func setImmovableProperties() {
        self.affectedByGravity = false
        self.allowsRotation = false
        self.isDynamic = false
    }
}
