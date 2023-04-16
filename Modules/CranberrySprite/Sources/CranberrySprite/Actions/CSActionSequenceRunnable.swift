//
//  CSActionSequenceRunnable.swift
//
//
//  Created by Marquis Kurt on 8/8/22.
//

import SpriteKit

/// A protocol that indicates an object is capable of running a sequence of actions.
public protocol CSActionSequenceRunnable {
    /// Run a sequence of SKActions.
    /// - Parameter sequence: The array of actions that will be run in sequence.
    func runSequence(_ sequence: [SKAction])

    /// Run a sequence of SKActions.
    /// - Parameter builder: A closure that returns an array of actions that will be run in sequence.
    func runSequence(@CSActionBuilder _ builder: () -> [SKAction])

    /// Run a sequence of SKActions.
    /// - Parameter sequence: The array of actions that will be run in sequence.
    /// - Parameter completion: A completion block called when the action completes.
    func runSequence(_ sequence: [SKAction], completion: @escaping () -> Void)

    /// Run a sequence of SKActions.
    /// - Parameter builder: A closure that returns an array of actions that will be run in sequence.
    /// - Parameter completion: A completion block called when the action completes.
    func runSequence(@CSActionBuilder _ builder: () -> [SKAction], completion: @escaping () -> Void)
}

extension SKNode: CSActionSequenceRunnable {
    public func runSequence(_ sequence: [SKAction]) {
        run(.sequence(sequence))
    }

    public func runSequence(@CSActionBuilder _ builder: () -> [SKAction]) {
        run(.sequence(builder()))
    }

    public func runSequence(_ sequence: [SKAction], completion: @escaping () -> Void) {
        run(.sequence(sequence), completion: completion)
    }

    public func runSequence(@CSActionBuilder _ builder: () -> [SKAction], completion: @escaping () -> Void) {
        run(.sequence(builder()), completion: completion)
    }
}
