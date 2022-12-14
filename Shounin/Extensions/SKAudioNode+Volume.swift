//
//  SKAudioNode+Volume.swift
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
    func setVolume(to volume: Float) {
        avAudioNode?.engine?.mainMixerNode.volume = volume
        avAudioNode?.reset()
    }

    func reset() {
        run(.run { [weak self] in
            self?.avAudioNode?.reset()
        })
    }
}
