//
//  PaintbrushScene+PaintbrushSceneSolvedDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/21/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import SpriteKit
import Paintbrush
import Bunker

extension PaintbrushScene: PaintbrushSceneSolvedStateDelegate {
    func savePlayerDrawingForReuse() {
        guard let puzzle, let image = getImageForSolvedCanvas() else { return }
        image.write(to: "solved_" + puzzle.expectedResult)
    }

    func loadSolvedStateIfPresent() {
        guard let puzzle else { return }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let firstPath = paths[0]
        let url = firstPath.appending(path: "solved_\(puzzle.expectedResult)")
            .appendingPathExtension("png")
        url.accessInSecurityScopedResource { [weak self] in
            guard let solvedNode = self?.childNode(withName: "//solveOverlay") as? SKSpriteNode else { return }
            if let tex = SKTexture(contentsOf: url) {
                solvedNode.texture = tex
            } else {
                solvedNode.isHidden = true
            }
        }
    }

    func getImageForSolvedCanvas() -> CGImage? {
        guard let panelDrawingArea, let drawingDelegateNode, solveState == .solved else { return nil }
        panelDrawingArea.lineWidth = 0
        guard let texture = view?.texture(from: drawingDelegateNode, crop: panelDrawingArea.frame) else {
            panelDrawingArea.lineWidth = 4
            return nil
        }
        panelDrawingArea.lineWidth = 4
        return texture.cgImage()
    }
}
