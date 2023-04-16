//
//  CSSoundNode+Modifiers.swift
//  
//
//  Created by Marquis Kurt on 11/23/22.
//

import SpriteKit

/// A protocol for sound nodes that act positionally.
public protocol CSSoundPositional {
    /// The position of the node in the world. Acts globally when defined as `nil`.
    var position: CGPoint? { get set }

    /// Sets the position of the ambient sound to a specified location. When provided, the ambient sound will play from
    /// that location as a positional node, provided that a listener node exists in the scene.
    ///
    /// - Parameter position: The location of the ambient sound.
    func positioned(at position: CGPoint) -> Self
}

extension RawAudio: CSSoundPositional {
    public func positioned(at position: CGPoint) -> Self {
        var ambience = RawAudio(name: name)
        ambience.position = position
        return ambience
    }
}

extension Ambience: CSSoundPositional {
    public func positioned(at position: CGPoint) -> Self {
        var ambience = Ambience(name: name, volume: volume)
        ambience.position = position
        return ambience
    }
}
