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

struct PaintbrushDemoView: View {
    private var paintbrushDemoScene: SKScene = {
        let scene = PaintbrushScene(fileNamed: "Stage1")
        scene?.scaleMode = .aspectFill
        return scene ?? PaintbrushScene(size: .init(width: 1600, height: 900))
    }()

    var body: some View {
        ZStack {
            Color.black
            SpriteView(
                scene: paintbrushDemoScene,
                transition: .fade(withDuration: 2),
                debugOptions: [.showsNodeCount, .showsFPS]
            )
            .aspectRatio(16 / 9, contentMode: .fit)
        }
    }
}
