//
//  CSAnimateable.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

import SpriteKit

/// A protocol that defines an animation capability.
public protocol CSAnimateable {
    associatedtype Frame

    /// Get a list of frames from an atlas.
    /// - Parameter atlas: The atlas to read animation frames from.
    /// - Parameter reversible: Whether the animation should play in reverse afterwards.
    /// - Parameter format: A closure that returns how the name format should be constructed.
    /// - Returns: A list of textures that make up the animation.
    static func animated(fromAtlas atlas: Self, reversible: Bool, format: (Int) -> String) -> [Frame]
}

extension SKTextureAtlas: CSAnimateable {
    /// Returns a string that uses the default sprite naming convention of `sprite_<num>`.
    public static func defaultSpriteNameFormat(iteration: Int) -> String {
        String(format: "sprite_%02d", iteration)
    }

    /// Get a list of frames from an atlas whose sprites are in the format `sprite_<num>`.
    /// - Parameter atlas: The atlas to read animation frames from.
    /// - Parameter reversible: Whether the animation should play in reverse afterwards. Defaults to false.
    /// - Parameter format: A closure that returns how the name format should be constructed. Defaults to
    /// ``SKTextureAtlas.defaultSpriteNameFormat(iteration:)``.
    /// - Returns: A list of textures that make up the animation.
    public static func animated(
        fromAtlas atlas: SKTextureAtlas,
        reversible: Bool = false,
        format: (Int) -> String = defaultSpriteNameFormat
    ) -> [SKTexture] {
        var frames: [SKTexture] = []
        for iter in 0 ..< atlas.textureNames.count {
            let name = format(iter)
            frames.append(atlas.textureNamed(name))
        }
        if reversible { frames += frames.reversed() }
        return frames
    }

    /// Convert this atlas to a list of animated frames.
    /// - Parameter reversible: Whether the animation should play in reverse afterwards. Defaults to false.
    /// - Returns: A list of textures that make up the animation.
    public func animated(reversible: Bool = false, format: (Int) -> String = defaultSpriteNameFormat) -> [SKTexture] {
        SKTextureAtlas.animated(fromAtlas: self, reversible: reversible, format: format)
    }
}
