//
//  GameEnvironmentCaslonDelegate.swift
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

import Caslon
import SpriteKit

/// A delegate that handles opening Caslon scenes in the game world.
public protocol GameEnvironmentCaslonDelegate: AnyObject {
    /// Loads the ending Caslon scene if it is present in the game's files.
    func loadEndingCaslonSceneIfPresent()

    /// Sets the ending Caslon scene that will be loaded.
    func setEndingScene(to caslonName: String)
}
