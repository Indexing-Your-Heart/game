//
//  SKTexture+URLInit.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/7/22.
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

#if os(macOS)
import AppKit

extension SKTexture {
    convenience init?(contentsOf url: URL) {
        guard let image = NSImage(contentsOf: url) else { return nil }
        self.init(image: image)
    }
}
#endif

#if os(iOS) || os(tvOS)
import UIKit

extension SKTexture {
    convenience init?(contentsOf url: URL) {
        guard let image = try? UIImage(data: .init(contentsOf: url)) else { return nil }
        self.init(image: image)
    }
}
#endif
