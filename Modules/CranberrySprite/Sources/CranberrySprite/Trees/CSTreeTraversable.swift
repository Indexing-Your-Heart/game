//
//  CSTreeTraversable.swift
//  
//
//  Created by Marquis Kurt on 11/22/22.
//

import Foundation
import SpriteKit

/// A protocol that allows any object to be traversable as a tree.
public protocol CSTreeTraversable {
    /// The child element of this tree.
    associatedtype Leaf

    /// An array containing the children leaves of the tree.
    var children: [Leaf] { get }

    /// Runs a transformation function on the tree's leaves.
    /// - Parameter applyRecursively: Whether to traverse through the entire tree.
    /// - Parameter transform: The application function to perform on the leaves.
    func apply(recursively applyRecursively: Bool, transform: (Leaf) -> Void)
}

extension SKNode: CSTreeTraversable {
    public typealias Leaf = SKNode
    public func apply(recursively applyRecursively: Bool = false, transform: (Leaf) -> Void) {
        children.forEach { child in
            transform(child)
            if applyRecursively {
                child.apply(recursively: true, transform: transform)
            }
        }
    }
}
