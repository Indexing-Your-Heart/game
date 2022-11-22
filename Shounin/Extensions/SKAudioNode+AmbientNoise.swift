//
//  SKAudioNode+AmbientNoise.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/17/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SpriteKit
import CranberrySprite

extension SKAudioNode {
    /// Creates an audio node for playing ambient sounds.
    ///
    /// Ambient sounds are set at a lower volume and loop during autoplay. They are applied gobally and are not
    /// positional.
    /// - Parameter trackName: The name of the ambient track that this node will play.
    /// - Parameter volume: The node's volume when playing the ambience. Defaults to `0.2`.
    convenience init(ambientTrackNamed trackName: String, at volume: Float = 0.2) {
        self.init(fileNamed: trackName)
        setVolume(to: volume)
        run(.changeVolume(to: volume, duration: 0))
        isPositional = false
        autoplayLooped = true
    }

    /// Creates an audio node for playing sound effects.
    ///
    /// Sound effects are set at a lower volume, but do not autoplay. They are applied gobally and are positional.
    /// - Parameter trackName: The name of the sound effect track that this node will play.
    /// - Parameter volume: The node's volume when playing the sound effect. Defaults to `0.5`.
    convenience init(soundEffectNamed trackName: String, at volume: Float = 0.5) {
        self.init(fileNamed: trackName)
        setVolume(to: volume)
        isPositional = true
        autoplayLooped = false
    }

    func setVolume(to volume: Float) {
        avAudioNode?.engine?.mainMixerNode.volume = volume
        avAudioNode?.reset()
    }

    /// Plays an audio node and removes itself from the scene tree.
    func playAndQueueFree() {
        runSequence {
            SKAction.play()
            SKAction.run { [weak self] in
                self?.removeFromParent()
            }
        }
    }

    /// Plays the current audio stream without removing it from the scene tree.
    func play() {
        run(.play())
    }

    func reset() {
        run(.run { [weak self] in
            self?.avAudioNode?.reset()
        })
    }
}