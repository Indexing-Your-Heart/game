//
//  File.swift
//
//
//  Created by Marquis Kurt on 11/23/22.
//

import SpriteKit

/// A result builder capable of building soundscapes.
///
/// Soundscapes can be defined as raw `SKAudioNodes`, or defined with customized ``CSSoundNode`` structs that will be
/// created into `SKAudioNodes`. They can be used interchangably to create the perfect soundscape.
///
/// For example, to build an ambient soundscape with ``CSSoundNode`` objects, you can write the following for any
/// function that conforms to ``CSSoundscapeBuilderCapable``:
/// ```swift
/// buildSoundscape {
///     Ambience(name: "room_1", at: 0.15)
///     Ambience(name: "room_stills", at: 0.1)
///     Ambience(name: "electric_sparks", at: 0.2, position: .zero)
///     Music(name: "escape01", at: 0.5)
/// }
/// ```
@resultBuilder
public enum CSSoundscapeBuilder {
    public static func buildArray(_ components: [[SKAudioNode]]) -> [SKAudioNode] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[CSSoundNode]]) -> [SKAudioNode] {
        components.flatMap { list in
            list.map { $0.buildAudioNode() }
        }
    }

    public static func buildBlock(_ components: [SKAudioNode]...) -> [SKAudioNode] {
        components.flatMap { $0 }
    }

    public static func buildBlock(_ components: [CSSoundNode]...) -> [SKAudioNode] {
        components.flatMap { list in
            list.map { $0.buildAudioNode() }
        }
    }

    public static func buildEither(first component: [SKAudioNode]) -> [SKAudioNode] {
        component
    }

    public static func buildEither(second component: [SKAudioNode]) -> [SKAudioNode] {
        component
    }

    public static func buildEither(first component: [CSSoundNode]) -> [SKAudioNode] {
        component.map { $0.buildAudioNode() }
    }

    public static func buildEither(second component: [CSSoundNode]) -> [SKAudioNode] {
        component.map { $0.buildAudioNode() }
    }

    public static func buildExpression(_ expression: SKAudioNode) -> [SKAudioNode] {
        [expression]
    }

    public static func buildExpression(_ expression: [SKAudioNode]) -> [SKAudioNode] {
        expression
    }

    public static func buildExpression(_ expression: CSSoundNode) -> [SKAudioNode] {
        [expression.buildAudioNode()]
    }

    public static func buildExpression(_ expression: [CSSoundNode]) -> [SKAudioNode] {
        expression.map { $0.buildAudioNode() }
    }
}

/// A protocol that handles building soundscapes.
public protocol CSSoundscapeBuilderCapable {
    /// Builds a soundscape and attaches it to a listener, if provided.
    /// - Parameter listener: The listener node that will be referenced for position nodes.
    /// - Parameter builder: The builder action that will build the soundscape.
    func buildSoundscape(listeningTo listener: SKNode?, @CSSoundscapeBuilder _ builder: () -> [SKAudioNode])
}

extension SKScene: CSSoundscapeBuilderCapable {
    public func buildSoundscape(
        listeningTo listener: SKNode? = nil,
        @CSSoundscapeBuilder _ builder: () -> [SKAudioNode]
    ) {
        self.listener = listener
        builder().forEach { sound in
            self.addChild(sound)
        }
    }
}
