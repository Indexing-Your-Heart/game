//
//  CaslonActor.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 4/14/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Caslon
import Celestia
import Foundation

class CaslonActor: CaslonSceneActionProviding {
    func sceneRequestsDismissingTutorial() -> Bool? {
        AppDelegate.currentFlow.currentBlock?.showTutorials
    }

    func sceneWillEnd() {
        AppDelegate.currentFlow.next()
        if AppDelegate.currentFlow.currentBlock == nil {
            exit(0)
        }
    }
}
