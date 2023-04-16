//
//  GameEnvironment+Caslon.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/16/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
//

import Bedrock
import Caslon
import SpriteKit

extension GameEnvironment: BedrockCaslonDelegate {
    func loadEndingCaslonSceneIfPresent() {
        guard let vnScene = CaslonScene(fileNamed: "Caslon Scene") else { return }
        vnScene.scaleMode = scaleMode
        vnScene.loadScript(named: completionCaslonName)
        vnScene.setActor(to: CaslonActor())
        teardown()
        view?.presentScene(vnScene, transition: .fade(withDuration: 3.0))
    }

    func setEndingScene(to caslonName: String) {
        completionCaslonName = caslonName
    }
}
