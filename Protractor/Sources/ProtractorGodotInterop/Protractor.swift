//
//  Protractor.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/19/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftGodot

@GodotMain
class LibProtractor: GodotExtensionDelegate {
    func extensionWillInitialize() {
        GD.pushWarning(
            """
            ProtractorGodotInterop is deprecated and will be removed in a future update.

            Future puzzles should utilize the Ashashat library.
            """
        )
    }
    func extensionDidInitialize(at level: GDExtension.InitializationLevel) {
        register(type: ProtractorDrawer.self)
    }
}
