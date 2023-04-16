//
//  BedrockLayer.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 4/16/23.
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

import Foundation

/// An enumeration that encodes layer names to corresponding types. This is used for world setup to perform certain
/// tasks such as gathering walkable tiles for pathfinding.
public enum BedrockLayer: String {
    /// The layer that represents the walkable tiles used for the graph.
    case walkingGraph = "Graph"

    /// The layer that represents the bounds where the player cannot cross.
    case bounds = "Bounds"

    /// The layer that contains information on where the player exists.
    case playerInsert = "PLAYER_INSERT"

    /// The layer that contains information on how puzzles are laid out in the world.
    case paintbrush = "PNT_LAYOUT"

    /// The layer that contains informaton on how the metapuzzle is laid out in the world.
    case paintbrushMetapuzzle = "PNT_LAYOUT_META"

    /// A generic, unspecified layer.
    case other
}
