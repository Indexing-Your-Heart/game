//
//  GameSceneView.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/1/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Celestia
import SpriteKit
import SwiftUI

struct GameSceneView: View {
    @AppStorage("dbg:show-nodes") var dbgShowNodes = false
    @AppStorage("dbg:show-fps") var dbgShowFPS = false
    @State private var debugOptions: SpriteView.DebugOptions = []
    @ObservedObject var currentFlow: CelestialFlowViewModel

    var body: some View {
        ZStack {
            Color.black
            SpriteView(
                scene: getGameSceneInCurrentContext(),
                transition: .fade(withDuration: 2),
                debugOptions: debugOptions
            )
            .aspectRatio(16 / 9, contentMode: .fit)
        }
        .onAppear {
            configureDebugSettings()
        }
    }

    private func getGameSceneInCurrentContext() -> some SKScene {
        let scene = GameEnvironment(stageNamed: currentFlow.currentBlock?.stage ?? "Stage1")
        scene.setEndingScene(to: currentFlow.currentBlock?.chapter ?? "epilogue")
        return scene
    }

    private func configureDebugSettings() {
        if dbgShowNodes { debugOptions.insert(.showsNodeCount) }
        if dbgShowFPS { debugOptions.insert(.showsFPS) }
    }
}
