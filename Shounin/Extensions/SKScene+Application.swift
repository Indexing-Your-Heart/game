//
//  SKScene+Application.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/9/22.
//

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
