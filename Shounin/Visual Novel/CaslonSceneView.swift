//
//  PaintbrushDemoView.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/22.
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
import SwiftUI

struct CaslonSceneView: View {
    var script: String

    init(script: String) {
        self.script = script
    }

    private var caslonScene: SKScene = {
        let scene = CaslonScene(fileNamed: "Caslon Scene")
        scene?.scaleMode = .aspectFit
        return scene ?? SKScene()
    }()

    var body: some View {
        ZStack {
            Color.black
            SpriteView(
                scene: caslonScene,
                transition: .fade(withDuration: 2)
            )
            .aspectRatio(16 / 9, contentMode: .fit)
        }
        .onAppear {
            if let scene = caslonScene as? CaslonScene {
                scene.loadScript(named: script)
            }
        }
    }
}
