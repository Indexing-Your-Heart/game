//
//  CSPixelArtConfigurable.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

import SpriteKit

/// A protocol that indicates an object is capable of configuring its textures for pixel art.
public protocol CSPixelArtConfigurable {
    /// Configures the current sprite so that its texture renders pixel art correctly.
    func configureForPixelArt()
}

extension SKSpriteNode: CSPixelArtConfigurable {
    public func configureForPixelArt() {
        texture?.filteringMode = .nearest
    }
}

extension SKTexture: CSPixelArtConfigurable {
    public func configureForPixelArt() {
        filteringMode = .nearest
    }
}
