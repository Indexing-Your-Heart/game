# ``CranberrySprite``

Take your SpriteKit games to the next level.

## Overview

**Cranberry Sprite** is a utility package that adds extra functionality
and quality-of-life updates to SpriteKit.

Some features include the following:

- Protocols for parsing SKTileMapNodes to create SKSpriteNodes from them.
- Extensions to CGPoint and CGVector to get distances.
- Extensions to SKSpriteNode to make them configurable for pixel art games.
- Extensions to SKTextureAtlas to add animation frame support.

## Topics

### Tilemaps and World Parsing

Construct worlds using SpriteKit tilemap nodes in a functional way.

- ``CSTileMapParseable``
- ``CSTileMapDefinition``
- ``CSWorldCreateable``

### Animations and Actions

Run sequences of actions more intuitively and fetch sprite animations easily.

- ``CSAnimateable``
- ``CSActionSequenceRunnable``
- ``CSActionBuilder``

### Pixel Art

Configure textures and sprites that work best for pixel art.

- ``CSPixelArtConfigurable``

### Vectors and Distances

Get the distances of two points more easily.

- ``CSDistanceComparable``

### Trees and Application

Do more with scenes and nodes represented as trees.

- ``CSTreeTraversable``

### Physics

Quickly make physics bodies with protocols that have predefined settings.
`SKPhysicsBody` conforms to these protocols already.

- ``CSPhysicsImmovableCreator``

### Ambient Soundscapes and Music

Play music and ambient soundscapes easily and performantly.

- ``CSAudioNodeCreator``
- ``CSSoundscapeBuilder``
- ``CSSoundscapeBuilderCapable``

### Soundscape Builders

Create sound effects, music, and ambience quickly using the soundscape builder.
You can use the predefined sound nodes or write your own using ``CSSoundNode``.

- ``CSSoundNode``
- ``SoundEffect``
- ``Music``
- ``Ambience``
- ``RawAudio``

### Soundscape Modifiers
- ``CSSoundPositional``

### Custom Nodes

Use brand-new nodes to simplify development and scene generation.

- ``CSStackNode``
