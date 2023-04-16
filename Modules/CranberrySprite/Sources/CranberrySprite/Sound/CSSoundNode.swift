//
//  CSSoundNode.swift
//  
//
//  Created by Marquis Kurt on 11/23/22.
//

import SpriteKit

/// A protocol that represents a sound node in a soundscape.
public protocol CSSoundNode {
    /// Builds the audio node into an `SKAudioNode`.
    func buildAudioNode() -> SKAudioNode
}

/// A sound node that represents a raw audio node, with no modifications.
public struct RawAudio: CSSoundNode {
    /// The name of the audio to play.
    public var name: String

    /// The position where the audio will be played.
    public var position: CGPoint? = nil

    public init(name: String) {
        self.name = name
        self.position = nil
    }

    public func buildAudioNode() -> SKAudioNode {
        let node = SKAudioNode(fileNamed: name)
        if let position = self.position {
            node.isPositional = true
            node.position = position
        }
        return node
    }
}

/// A sound node that represents an ambient track.
public struct Ambience: CSSoundNode {
    /// The audio track that will be played as ambient sound.
    public var name: String

    /// The volume that the node will be played at. Defaults to `0.1`.
    public var volume: Float = 0.1

    /// The position of the node in the world. Acts globally when defined as `nil`.
    public var position: CGPoint? = nil

    public init(name: String, volume: Float) {
        self.name = name
        self.volume = volume
        self.position = nil
    }

    public func buildAudioNode() -> SKAudioNode {
        let node = SKAudioNode.ambience(named: name, at: volume)
        if let position = self.position {
            node.isPositional = true
            node.position = position
        }
        return node
    }
}

/// A sound node that represents background music.
public struct Music: CSSoundNode {
    /// The name of the music that will be played.
    public var name: String

    /// The volume that the music will be played at. Defaults to `1.0`.
    public var volume: Float = 1.0

    public init(name: String, volume: Float) {
        self.name = name
        self.volume = volume
    }

    public func buildAudioNode() -> SKAudioNode {
        SKAudioNode.music(named: name, at: volume)
    }
}

/// A sound node that represents a sound effect.
public struct SoundEffect: CSSoundNode {
    /// The name of the sound effect that will be played.
    public var name: String

    /// The volume that the sound effect will be played at. Defaults to `1.0`.
    public var volume: Float = 1.0

    /// The position where the sound effect is located.
    public var position: CGPoint

    public init(name: String, volume: Float, position: CGPoint) {
        self.name = name
        self.volume = volume
        self.position = position
    }

    public func buildAudioNode() -> SKAudioNode {
        let node = SKAudioNode(fileNamed: name)
        node.changeVolume(to: volume)
        node.isPositional = true
        node.autoplayLooped = false
        node.position = position
        return node
    }
}
