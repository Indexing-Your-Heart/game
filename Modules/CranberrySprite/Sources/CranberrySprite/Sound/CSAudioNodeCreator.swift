//
//  CSAudioNodeCreator.swift
//  
//
//  Created by Marquis Kurt on 11/23/22.
//

import SpriteKit
import AVFoundation

/// A protocol that handles creation of specialized audio nodes.
public protocol CSAudioNodeCreator {
    /// The audio node type that the creator will generate.
    associatedtype AudioNode

    /// Creates an audio node designed for ambient soundscapes.
    /// - Parameter trackName: The resource name of the track to use as ambience.
    /// - Parameter volume: The specified volume that the node should be played at.
    static func ambience(named trackName: String, at volume: Float) -> AudioNode

    /// Creates an audio node designed for music.
    /// - Parameter trackName: The resource name of the track to use as background music.
    /// - Parameter volume: The specified volume that the node should be played at.
    static func music(named trackName: String, at volume: Float) -> AudioNode

    /// Plays the audio node.
    func play()

    /// Plays the audio node, then frees it from the queue.
    func playThenFreeFromQueue()
}

extension SKAudioNode: CSAudioNodeCreator {
    public typealias AudioNode = SKAudioNode

    private static func createNonephemeralNode(trackNamed track: String) -> SKAudioNode {
        let node = SKAudioNode(fileNamed: track)
        node.autoplayLooped = true
        node.isPositional = false
        return node
    }

    public static func ambience(named trackName: String, at volume: Float = 0.1) -> SKAudioNode {
        let node = createNonephemeralNode(trackNamed: trackName)
        node.changeVolume(to: volume)
        return node
    }

    public static func music(named trackName: String, at volume: Float = 1.0) -> SKAudioNode {
        let node = createNonephemeralNode(trackNamed: trackName)
        node.changeVolume(to: volume)
        return node
    }

    public func changeVolume(to newVolume: Float) {
        self.run(.changeVolume(to: newVolume, duration: 0))
    }

    public func play() {
        self.run(.play())
    }

    public func playThenFreeFromQueue() {
        self.runSequence {
            SKAction.play()
            SKAction.run { [weak self] in
                self?.removeFromParent()
            }
        }
    }
}
