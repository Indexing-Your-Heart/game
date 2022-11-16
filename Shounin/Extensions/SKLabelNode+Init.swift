//
//  SKLabelNode+Init.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/15/22.
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

import SpriteKit

extension SKLabelNode {
    /// Initializes a label node with text and specified font settings.
    /// - Parameter text: The text contents of the label.
    /// - Parameter fontName: The name of the font that will be used in the label.
    /// - Parameter size: The font size of the label.
    convenience init(text: String?, with fontName: String, at size: CGFloat) {
        self.init(text: text)
        self.fontName = fontName
        fontSize = size
    }
}
