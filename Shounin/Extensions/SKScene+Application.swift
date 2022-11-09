//
//  GameEnvironment.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/9/22.
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

extension SKNode {
    /// Runs an application function on the children in the scene tree, relative to this node.
    /// - Parameter useRecursion: Whether to apply the function recursively on all children. Defaults to `false`.
    /// - Parameter application: The application function to run on each child node.
    func apply(recursively useRecursion: Bool = false, application: (SKNode) -> Void) {
        children.forEach { child in
            application(child)
            if useRecursion {
                child.apply(recursively: true, application: application)
            }
        }
    }
}
